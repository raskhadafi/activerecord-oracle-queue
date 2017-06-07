require "activerecord/oracle/queue/version"
require "activerecord/oracle/queue/railtie"

module Activerecord
  module Oracle
    module Queue
      autoload :Watcher, "activerecord/oracle/queue/watcher"
    end
  end
end
