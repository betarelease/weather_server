#!/bin/sh

cd "$(dirname "$0")"

python weather-script.py 37.5483 -121.9875
convert -background white weather-script-output.svg weather-script-output.png 
pngcrush -c0 w4 weather-script-output.png weather-output.png
cp -f weather-output.png /var/www/weather-script-output.png
