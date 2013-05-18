get "/" do
  "Welcome to the Weather App. You need to point your browser to /weather."
end

get '/weather' do
  local_weather
  send_file "#{File.join(settings.public_folder, 'weather_small.png')}",
      :type => 'image/png',
      :disposition => 'inline'
end

def local_weather(latitude=37.5483, longitude=-121.9875)
  weather = Weather.new(latitude, longitude)
  weather.fetch
  weather.process_svg

  stdin, stdout, stderr = Open3.popen3("rsvg-convert --background-color=white -o weather.png weather-script-output.svg")
  logger.info("rsvg-convert => #{stdin}, #{stdout}, #{stderr}")
  
  stdin, stdout, stderr = Open3.popen3("pngcrush -c0 w4 weather.png weather_small.png")
  logger.info("pngcrush => #{stdin}, #{stdout}, #{stderr}")
  
  stdin, stdout, stderr = Open3.popen3("mv -f weather_small.png #{settings.public_folder}")
  logger.info( "cp => #{stdin}, #{stdout}, #{stderr}")
end