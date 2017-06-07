module Activerecord
  module Oracle
    module Queue
      #
      # Class Activerecord::Oracle::Queue::Watcher provides behaviour for watching queues
      #
      # @author Roman Simecek <roman.simecek@swisslife-select.ch>
      #
      class Watcher < Module

        def initialize(queue_name)
          @queue_name = queue_name

          super()
        end

        def included(receiver)
          receiver.extend ClassMethods
          receiver.const_set :QueueName, @queue_name
        end

        module ClassMethods

          def watch
            Rails.logger = Logger.new(STDOUT)
            connection   = fetch_connection
            cursor       = fetch_cursor(connection)

            cursor.bind_param(":p", nil, String, 4000)

            while true
              cursor.exec() # retrieve message

              json = JSON.parse(cur[":p"])
              instance = self.class.new
              instance.perform(json)

              connection.commit # remove from AQ.  dequeue isn't complete until this happens
            end
          end

          private

            def fetch_cursor(connection)
              connection.parse(
                "BEGIN #{self::QueueName}_queue.dequeue_message(:p); END;"
              )
            end

            def fetch_connection
              OCI8.new(
                db_config[:username],
                db_config[:password],
                db_config[:database],
              )
            end

            def db_config
              ActiveRecord::Base.connection_config
            end
        end
      end
    end
  end
end
