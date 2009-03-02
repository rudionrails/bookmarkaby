if defined? ::ActionView::Base
  require File.dirname(__FILE__) + '/lib/bookmarkaby'
  ActionView::Base.send :include, Rudionrails::Bookmarkaby
else
  $stderr.puts "Skipping Bookmarkaby plugin. `gem install actionpack` and try again."
end
