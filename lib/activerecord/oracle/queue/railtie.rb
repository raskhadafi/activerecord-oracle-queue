require "rails"
require "activerecord/oracle/queue/glue"

module Activerecord
  module Oracle
    module Queue
      class Railtie < Rails::Railtie
        initializer "activerecord.oracle.queue.insert_into_active_record" do |app|
          ActiveRecord::Base.send(
            :include,
            Activerecord::Oracle::Queue::Glue
          )
        end
      end
    end
  end
end
