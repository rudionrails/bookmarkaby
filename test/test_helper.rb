require 'rubygems'
require 'active_support'
require 'active_support/test_case'

# gem install redgreen for colored test output
begin require 'redgreen'; rescue LoadError; end

begin
  require "action_view"
  require 'action_controller'
rescue LoadError
  $stderr.puts "Unable to run Bookmarkaby tests. `gem install actionpack` and try again."
else
  require File.dirname(__FILE__) + "/../init"
end

