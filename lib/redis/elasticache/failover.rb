require 'redis'

class Redis

  module Connection
    class Ruby
      ELASTICACHE_READONLY_ERROR_PREFIX = "READONLY".freeze
      ELASTICACHE_LOADING_ERROR_PREFIX = "LOADING".freeze
      ELASTICACHE_READONLY_MESSAGE = "A write operation was issued to an ELASTICACHE replica node that is READONLY.".freeze
      ELASTICACHE_LOADING_MESSAGE = "A write operation was issued to an ELASTICACHE node that was previously READONLY and is now LOADING.".freeze

      # Amazon RDS supports failover, but because it uses DNS magic to point to
      # the master node, TCP connections are not disconnected and we can issue
      # write operations to a node that is no longer the master. Under normal 
      # conditions this should be interpreted as a `CommandError`, but with RDS
      # replication groups, we should consider this a `BaseConnectionError` so we
      # terminate the connection, reconnect and retry the operation with the
      # correct node as the master accepting writes.
      def format_error_reply(line)
        error_message = line.strip
        if error_message_has_prefix?(ELASTICACHE_READONLY_ERROR_PREFIX, error_message)
          raise BaseConnectionError, ELASTICACHE_READONLY_MESSAGE
        elsif error_message_has_prefix?(ELASTICACHE_LOADING_ERROR_PREFIX, error_message)
          raise BaseConnectionError, ELASTICACHE_LOADING_MESSAGE
        else
          CommandError.new(error_message)
        end
      end

      private
      def error_message_has_prefix?(prefix, error_message)
        (error_message.slice(0, prefix.length) === prefix)
      end
    end
  end
end
