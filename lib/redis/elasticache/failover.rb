require 'redis'

class Redis

  module Connection
    class Ruby

      ELASTICACHE_READONLY_ERROR = "READONLY You can't write against a read only slave.".freeze
      ELASTICACHE_READONLY_MESSAGE = "A write operation was issued to an ELASTICACHE slave node that is READONLY.".freeze

      # Amazon RDS supports failover, but because it uses DNS magic to point to
      # the master node, TCP connections are not disconnected and we can issue
      # write operations to a node that is no longer the master. Under normal 
      # conditions this should be interpreted as a `CommandError`, but with RDS
      # replication groups, we should consider this a `BaseConnectionError` so we
      # terminate the connection, reconnect and retry the operation with the
      # correct node as the master accepting writes.
      def format_error_reply(line)
        error_message = line.strip
        if error_message == ELASTICACHE_READONLY_ERROR
          raise BaseConnectionError, ELASTICACHE_READONLY_MESSAGE
        else
          CommandError.new(error_message)
        end
      end

    end
  end
end
