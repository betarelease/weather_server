#!/usr/bin/python2

# Kindle Weather Display
# Matthew Petroff (http://www.mpetroff.net/)
# September 2012

import urllib2
from xml.dom import minidom
import datetime
import codecs
import sys


#
# Download and parse weather data
#

# Fetch data (change lat and lon to desired location)
latitude = sys.argv[1]
longitude = sys.argv[2] 

url_for_location = "http://graphical.weather.gov/xml/SOAP_server/ndfdSOAPclientByDay.php?whichClient=NDFDgenByDay&lat=" + latitude + "&lon=" + longitude + "&format=24+hourly&numDays=4&Unit=e"
weather_xml = urllib2.urlopen(url_for_location).read()
dom = minidom.parseString(weather_xml)

# Parse temperatures
xml_temperatures = dom.getElementsByTagName('temperature')
highs = [None]*4
lows = [None]*4
for item in xml_temperatures:
    if item.getAttribute('type') == 'maximum':
        values = item.getElementsByTagName('value')
        for i in range(len(values)):
            highs[i] = int(values[i].firstChild.nodeValue)
    if item.getAttribute('type') == 'minimum':
        values = item.getElementsByTagName('value')
        for i in range(len(values)):
            lows[i] = int(values[i].firstChild.nodeValue)

# Parse icons
xml_icons = dom.getElementsByTagName('icon-link')
icons = [None]*4
for i in range(len(xml_icons)):
    icons[i] = xml_icons[i].firstChild.nodeValue.split('/')[-1].split('.')[0].rstrip('0123456789')

# Parse dates
xml_day_one = dom.getElementsByTagName('start-valid-time')[0].firstChild.nodeValue[0:10]
day_one = datetime.datetime.strptime(xml_day_one, '%Y-%m-%d')



#
# Preprocess SVG
#

# Open SVG to process
output = codecs.open('weather-script-preprocess.svg', 'r', encoding='utf-8').read()

# Insert icons and temperatures
output = output.replace('ICON_ONE',icons[0])
output = output.replace('ICON_TWO',icons[1])
output = output.replace('ICON_THREE',icons[2])
output = output.replace('ICON_FOUR',icons[3])

output = output.replace('HIGH_ONE',str(highs[0]))
output = output.replace('HIGH_TWO',str(highs[1]))
output = output.replace('HIGH_THREE',str(highs[2]))
output = output.replace('HIGH_FOUR',str(highs[3]))

output = output.replace('LOW_ONE',str(lows[0]))
output = output.replace('LOW_TWO',str(lows[1]))
output = output.replace('LOW_THREE',str(lows[2]))
output = output.replace('LOW_FOUR',str(lows[3]))

# Insert days of week
days_of_week = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
one_day = datetime.timedelta(days=1)

output = output.replace('DAY_ONE',days_of_week[day_one.weekday()])
output = output.replace('DAY_TWO',days_of_week[(day_one + one_day).weekday()])
output = output.replace('DAY_THREE',days_of_week[(day_one + 2*one_day).weekday()])
output = output.replace('DAY_FOUR',days_of_week[(day_one + 3*one_day).weekday()])

# Write output
codecs.open('weather-script-output.svg', 'w', encoding='utf-8').write(output)
