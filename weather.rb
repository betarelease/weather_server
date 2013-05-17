require 'nokogiri'
require 'httparty'
require 'nori'

class Weather
  include HTTParty

  attr_accessor :highs, :lows, :icons, :start_date
  def initialize(latitude, longitude)
    @latitude = latitude
    @longitude = longitude
  end
  
  def fetch
    @uri = "http://graphical.weather.gov/xml/SOAP_server/ndfdSOAPclientByDay.php?whichClient=NDFDgenByDay&lat=#{@latitude}&lon=#{@longitude}&format=24+hourly&numDays=4&Unit=e"
    response = self.class.get( "#{@uri}")
    data = Nori.new.parse( response.body )
    temperatures = data["dwml"]["data"]["parameters"]["temperature"]
    @highs = temperatures.first["value"]
    @lows = temperatures.last["value"]
    @icons = data["dwml"]["data"]["parameters"]["conditions_icon"]["icon_link"]
    @start_date = data["dwml"]["data"]["time_layout"].first["start_valid_time"].first
  end
  
  def process_svg
    svg_file = "./weather-script-preprocess.svg"
    
    output = File.read(svg_file)
    output.gsub!('HIGH_ONE',   @highs[0])
    output.gsub!('HIGH_TWO',   @highs[1])
    output.gsub!('HIGH_THREE', @highs[2])
    output.gsub!('HIGH_FOUR',  @highs[3])

    output.gsub!('LOW_ONE',   @lows[0])
    output.gsub!('LOW_TWO',   @lows[1])
    output.gsub!('LOW_THREE', @lows[2])
    output.gsub!('LOW_FOUR',  @lows[3])
    
    output.gsub!('ICON_ONE',  @icons[0])
    output.gsub!('ICON_TWO',  @icons[1])
    output.gsub!('ICON_THREE',@icons[2])
    output.gsub!('ICON_FOUR', @icons[3])
    
    # xml_day_one = dom.getElementsByTagName('start-valid-time')[0].firstChild.nodeValue[0:10]
    # 
    # # Insert days of week
    # days_of_week = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
    # one_day = datetime.timedelta(days=1)
    # 
    # output.gsub!('DAY_ONE',days_of_week[day_one.weekday()])
    # output.gsub!('DAY_TWO',days_of_week[(day_one + one_day).weekday()])
    # output.gsub!('DAY_THREE',days_of_week[(day_one + 2*one_day).weekday()])
    # output.gsub!('DAY_FOUR',days_of_week[(day_one + 3*one_day).weekday()])
    

    File.open("./weather-script-output.svg", "w") {|file| file.puts output}
  end
  
end

