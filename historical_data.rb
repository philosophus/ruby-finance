require 'open-uri'
require 'uri'
require 'csv'

class HistoricalData

	attr_reader :data

	def initialize(symbol)
		# Get historical data from Yahoo Finance
		file = open(URI.escape("http://ichart.finance.yahoo.com/table.csv?s=#{symbol}&a=00&b=01&c=1800&d=#{Time.now.month-1}&e=#{Time.now.day}&f=#{Time.now.year}&g=d&ignore=.csv"))
		# Parse CSV data, drop first line and convert entries from strings to date, float or integers
		@data = CSV.parse(file)[1..-1].map {|e| [Time.parse(e[0]), e[1].to_f, e[2].to_f, e[3].to_f, e[4].to_f, e[5].to_i, e[6].to_f, ]}
	end
end