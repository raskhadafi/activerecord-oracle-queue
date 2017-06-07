module Activerecord
  module Oracle
    module Queue
      #
      # Module Activerecord::Oracle::Queue::Schema provides migrations for oracle queues
      #
      # @author Roman Simecek <roman.v.simecek@gmail.com>
      #
      module Schema

        def self.included(base)
          ActiveRecord::ConnectionAdapters::AbstractAdapter.send(:include, Statements)
        end

        module Statements

          def add_queue(queue_name, payload_name: "message_t", payload_object: "json VARCHAR2(4000)")
            raise ArgumentError, "The queue name can not be longer than 20 chars." if queue_name.length > 20

            add_queue_message_type(payload_name, payload_object)
            execute(<<-SQL)
              BEGIN
                DBMS_AQADM.CREATE_QUEUE_TABLE(
                  queue_table        => '#{queue_name}_tab',
                  queue_payload_type => '#{payload_name}'
                );

                DBMS_AQADM.CREATE_QUEUE(
                  queue_name  => '#{queue_name}',
                  queue_table => '#{queue_name}_tab'
                );

                DBMS_AQADM.START_QUEUE(
                  queue_name => '#{queue_name}'
                );
              END;
            SQL
          end

          def remove_queue(queue_name, payload_name: "message_t")
            execute(<<-SQL)
              BEGIN
                DBMS_AQADM.STOP_QUEUE(
                  queue_name => '#{queue_name}'
                );

                DBMS_AQADM.DROP_QUEUE(
                  queue_name => '#{queue_name}'
                );

                DBMS_AQADM.DROP_QUEUE_TABLE(
                  queue_table => '#{queue_name}_tab'
                );
              END;
            SQL
            remove_queue_message_type(payload_name)
          end

          private

            def add_queue_message_type(payload_name, payload_object)
              execute("CREATE OR REPLACE TYPE #{payload_name} AS OBJECT (#{payload_object})")
            end

            def remove_queue_message_type(payload_name)
              execute("DROP TYPE #{payload_name}")
            end
        end
      end
    end
  end
end
