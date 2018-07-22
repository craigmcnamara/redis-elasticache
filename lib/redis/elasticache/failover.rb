# frozen_string_literal: true

require 'redis'

class Redis
  module Elasticache
    module Failover
      ELASTICACHE_READONLY_ERROR   = "READONLY You can't write against a read only slave."
      ELASTICACHE_READONLY_MESSAGE = 'A write operation was issued to an ElastiCache slave node.'

      # Amazon RDS supports failover, but because it uses DNS magic to point to
      # the master node, TCP connections are not disconnected and we can issue
      # write operations to a node that is no longer the master. Under normal
      # conditions this should be interpreted as a `CommandError`, but with RDS
      # replication groups, we should consider this a `BaseConnectionError` so we
      # terminate the connection, reconnect and retry the operation with the
      # correct node as the master accepting writes.

      def read
        super
      rescue CommandError => error
        if error.message == ELASTICACHE_READONLY_ERROR
          raise BaseConnectionError, ELASTICACHE_READONLY_MESSAGE
        end
        raise error
      end
    end
  end

  module Connection
    class Ruby
      prepend Elasticache::Failover
    end

    if defined?(Hiredis)
      class Hiredis
        prepend Elasticache::Failover
      end
    end
  end
end
