Thread.new do
  while true do
     sleep 15
     weather = Weather.new(37.5483, -121.9875)
     weather.fetch
     weather.process_svg

     stdin, stdout, stderr = Open3.popen3("rsvg-convert --background-color=white -o weather-script-output.png weather-script-output.svg")
     puts "[DEBUG] stdin, stdout, stderr => #{stdin}, #{stdout}, #{stderr}"
     
     stdin, stdout, stderr = Open3.popen3("pngcrush -c0 w4 weather-script-output.png weather.png")
     puts "[DEBUG] stdin, stdout, stderr => #{stdin}, #{stdout}, #{stderr}"
     
     stdin, stdout, stderr = Open3.popen3("cp -f weather.png #{File.join(settings.public_folder, 'weather.png')}")
     puts "[DEBUG] stdin, stdout, stderr => #{stdin}, #{stdout}, #{stderr}"
  end
end
