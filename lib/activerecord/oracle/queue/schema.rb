require "erb"
require "pathname"

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
          ActiveRecord::ConnectionAdapters::AbstractAdapter.send :include, Statements
          ActiveRecord::Migration::CommandRecorder.send          :include, CommandRecorder
        end

        module Statements

          def add_queue(queue_name, payload_name: "message_t", payload_object: "json VARCHAR2(4000)")
            schema, queue_name = remove_schema_from_queue_name(queue_name)

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
            add_queue_package(binding)
          end

          def remove_queue(queue_name, payload_name: "message_t")
            schema, queue_name = remove_schema_from_queue_name(queue_name)

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
            execute("DROP PACKAGE #{queue_name}_queue")
          end

          private

            def remove_schema_from_queue_name(queue_name)
              if queue_name.include?(".")
                queue_name.split(".")[0,2]
              else
                [nil, queue_name]
              end
            end

            def add_queue_package(args)
              execute(
                render_package(args, :definition)
              )
              execute(
                render_package(args, :body)
              )
            end

            def render_package(args, file)
              ERB.new(
                package_template(file)
              ).result(
                args
              )
            end

            def package_template(file)
              IO.read(
                Pathname.new(__FILE__).join("../package/#{file}.sql")
              )
            end

            def add_queue_message_type(payload_name, payload_object)
              execute("CREATE OR REPLACE TYPE #{payload_name} AS OBJECT (#{payload_object})")
            end

            def remove_queue_message_type(payload_name)
              execute("DROP TYPE #{payload_name}")
            end
        end

        module CommandRecorder
          def add_queue(*args)
            record(:add_queue, args)
          end

          private

          def invert_add_queue(args)
            [:remove_queue, args]
          end
        end
      end
    end
  end
end
