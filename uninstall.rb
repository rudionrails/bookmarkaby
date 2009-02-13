# Remove images installed
RAILS_ROOT = File.join(File.dirname(__FILE__), '../../../') unless defined? RAILS_ROOT

FileUtils.rm_r(
  File.join(RAILS_ROOT, 'public', 'images', 'bookmarkaby'),
  :verbose => true
)