Dir[File.join(File.dirname(__FILE__), "*.rb")].each do |file|
  require file unless File.basename(file) == 'init.rb'
end