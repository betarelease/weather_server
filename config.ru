require 'sinatra'
RUBY_ROOT = File.expand_path( '../..', __FILE__ ) unless defined? RUBY_ROOT

configure do
  set :public_folder, File.join(File.dirname(__FILE__) + 'public')

  Dir["#{RUBY_ROOT}/**/*.rb"].each do |extension|
    require extension
  end
end

run Sinatra::Application