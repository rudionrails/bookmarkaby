# To "test" the copy -r code, next I'll test drive!
# ruby vendor/plugin/boolmarkaby install.rb
# RAILS_ROOT = "#{File.dirname(__FILE__)}/../../.." unless defined?(RAILS_ROOT)

require 'fileutils'

# Workaround a problem with script/plugin and http-based repos.
# See http://dev.rubyonrails.org/ticket/8189
Dir.chdir(Dir.getwd.sub(/vendor.*/, '')) do

  ##
  ## Copy over asset files (javascript/css/images) from the plugin directory to public/
  ##

  def copy_files(source_path, destination_path, directory)
    source, destination = File.join(directory, source_path), File.join(RAILS_ROOT, destination_path)

    puts "copying #{source}/* to #{destination}"
    FileUtils.cp_r(Dir.glob(source+'/*'), destination)
  end

  directory = File.dirname(__FILE__)
  copy_files("/assets", "/public", directory)
end