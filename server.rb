get "/" do
  "Welcome to the Weather App. You need to point your browser to /weather."
end

get '/weather' do
  local_weather
  logger.info "#{File.join(settings.public_folder, 'weather.png')}"
  send_file "#{File.join(settings.public_folder, 'weather.png')}"
end

def local_weather(latitude=37.5483, longitude=-121.9875)
  weather = Weather.new(latitude, longitude)
  weather.fetch
  weather.process_svg

  stdin, stdout, stderr = Open3.popen3("rsvg-convert --background-color=white -o weather.png weather-script-output.svg")
  logger.info("rsvg-convert => #{stdin}, #{stdout}, #{stderr}")
  
  stdin, stdout, stderr = Open3.popen3("cp -f weather.png #{File.join(settings.public_folder, 'weather.png')}")
  logger.info( "cp => #{stdin}, #{stdout}, #{stderr}")
end