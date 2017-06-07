require "activerecord/oracle/queue/schema"

module Activerecord
  module Oracle
    module Queue
      module Glue
        def self.included(base)
          base.send :include, Schema
        end
      end
    end
  end
end
