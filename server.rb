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

  `rsvg-convert --background-color=white -o weather.png weather-script-output.svg > rsvg-convert.log 2>&1`  
  `pngcrush -c0 w4 weather.png weather_small.png > pngcrush.log 2>&1`
end