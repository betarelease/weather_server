require 'sinatra'
RUBY_ROOT = File.expand_path( '../..', __FILE__ ) unless defined? RUBY_ROOT

configure do
  set :public_folder, File.join(File.dirname(__FILE__) + 'public')

  require File.join(File.dirname(__FILE__) + '/weather.rb')
  require File.join(File.dirname(__FILE__) + '/server.rb')

end

run Sinatra::Application