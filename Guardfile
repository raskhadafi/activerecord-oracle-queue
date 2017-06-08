notification(
  :terminal_notifier,
  app_name: "Activerecord::Oracle::Queue",
  activate: "com.googlecode.iTerm2"
) if `uname` =~ /Darwin/

guard :rspec, cmd: "bundle exec rspec", all_on_start: true do
  require "guard/rspec/dsl"

  dsl   = Guard::RSpec::Dsl.new(self)
  rspec = dsl.rspec
  ruby  = dsl.ruby

  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)
  dsl.watch_spec_files_for(ruby.lib_files)
end
