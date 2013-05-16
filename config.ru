require 'sinatra'
require 'open3'

configure do
  set :root, File.dirname(__FILE__)
  set :public_folder, Proc.new { File.join(root, 'public') }  

  enable :logging
  log_file = File.join("#{settings.root}", "#{settings.environment}.log")
  file = File.new(log_file, 'a+')
  file.sync = true
  use Rack::CommonLogger, file

  ruby_files = Dir.entries(settings.root).select {|rb| rb =~ /.rb/}
  ruby_files.each do |rb|
    require File.join(settings.root, rb)
  end

end

run Sinatra::Application