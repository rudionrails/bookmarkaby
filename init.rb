module Rudionrails
  module Bookmarkaby
    VERSION = "0.1.0"
  end
end

if defined? ::ActionView::Base
  require File.dirname(__FILE__) + '/lib/bookmarkaby'
else
  $stderr.puts "Skipping Bookmarkaby plugin. `gem install actionpack` and try again."
end
