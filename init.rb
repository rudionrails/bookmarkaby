require File.dirname(__FILE__) + '/lib/bookmarkaby'

if defined? ::ActionView::Base
  ActionView::Base.send :include, Rudionrails::Bookmarkaby
else
  $stderr.puts "Skipping Bookmarkaby plugin. `gem install actionpack` and try again."
end
