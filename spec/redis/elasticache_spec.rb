require 'spec_helper'

describe Redis::Elasticache do
  it 'has a version number' do
    expect(Redis::Elasticache::VERSION).not_to be nil
  end

  module CommandError
    def read
      raise Redis::CommandError.new("Derp.")
    end
  end

  module ReadOnlyError
    def read
      raise Redis::CommandError.new("READONLY You can't write against a read only slave.")
    end
  end

  context 'Redis::Connection::* patch' do
    let(:driver) { Class.new {} }
    let(:connection) { driver.new }

    it 'converts CommandError to BaseConnectionError when a write occurs against a slave node' do
      driver.send(:prepend, ReadOnlyError)
      driver.send(:prepend, Redis::Elasticache::Failover)

      expect { connection.read }.to raise_error(::Redis::BaseConnectionError)
    end

    it 'returns a CommandError in all other cases' do
      driver.send(:prepend, CommandError)
      driver.send(:prepend, Redis::Elasticache::Failover)

      expect { connection.read }.to raise_error(Redis::CommandError)
    end
  end
end
