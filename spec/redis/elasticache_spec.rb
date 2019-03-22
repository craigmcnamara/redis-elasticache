require 'spec_helper'

describe Redis::Elasticache do
  it 'has a version number' do
    expect(Redis::Elasticache::VERSION).not_to be nil
  end

  context 'Redis::Connection::Ruby#format_error_reply failover patch' do

    let(:connection) { Redis::Connection::Ruby.new nil }
    let(:read_only_response) { "READONLY You can't write against a read only replica." }

    it 'raises `BaseConnectionError` when a write occurs against a replica node' do
      expect { connection.format_error_reply read_only_response }.to raise_error Redis::BaseConnectionError
    end

    it 'returns a `CommandError` in all other cases' do
      expect(connection.format_error_reply 'Derp').to be_a Redis::CommandError
    end

  end

end
