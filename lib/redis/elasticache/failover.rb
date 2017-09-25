require 'redis'
class Redis
  module Connection
    RDS_READONLY_ERROR = "READONLY You can't write against a read only slave.".freeze
    RDS_READONLY_MESSAGE = "A write operation was issued to an RDS slave node.".freeze
    if defined?(Ruby)
      class Ruby
        # Amazon RDS supports failover, but because it uses DNS magic to point to
        # the master node, TCP connections are not disconnected and we can issue
        # write operations to a node that is no longer the master. Under normal
        # conditions this should be interpreted as a `CommandError`, but with RDS
        # replication groups, we should consider this a `BaseConnectionError` so we
        # terminate the connection, reconnect and retry the operation with the
        # correct node as the master accepting writes.
        def format_error_reply(line)
          error_message = line.strip
          if error_message == Redis::Connection::RDS_READONLY_ERROR
            raise BaseConnectionError, Redis::Connection::RDS_READONLY_MESSAGE
          else
            CommandError.new(error_message)
          end
        end
      end
    elsif defined?(Hiredis)
      #implementation for hiredis driver
      class Hiredis
        def read
          reply = @connection.read
          if reply.is_a?(RuntimeError)
              if reply.message.strip == Redis::Connection::RDS_READONLY_ERROR
                raise BaseConnectionError
              else
                reply = CommandError.new(reply.message)
              end
          end
          reply
          rescue BaseConnectionError
             raise ConnectionError, Redis::Connection::RDS_READONLY_MESSAGE
          rescue Errno::EAGAIN
             raise TimeoutError
          rescue RuntimeError => err
             raise ProtocolError.new(err.message)
          end
      end
    end
  end
end
