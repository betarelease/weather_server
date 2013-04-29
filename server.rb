Thread.new do
  while true do
     sleep 15
     weather = Weather.new(37.5483, -121.9875)
     weather.fetch
     weather.process_svg
     `rsvg-convert --background-color=white -o weather-script-output.png weather-script-output.svg`
     `pngcrush -c0 w4 weather-script-output.png weather.png`
     `cp -f weather.png #{File.join(File.dirname(__FILE__) + "/public/weather.png")}`
  end
end
