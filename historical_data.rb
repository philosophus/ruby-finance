require 'open-uri'
require 'uri'
require 'csv'
require 'json'

class HistoricalData

	attr_reader :data
	attr_reader :symbol

	def initialize(symbol, data)
		@symbol = symbol
		@data = data
	end

	def self.from_yahoo(symbol)
		# Get historical data from Yahoo Finance
		file = open(URI.escape("http://ichart.finance.yahoo.com/table.csv?s=#{symbol}&a=00&b=01&c=1800&d=#{Time.now.month-1}&e=#{Time.now.day}&f=#{Time.now.year}&g=d&ignore=.csv"))
		# Parse CSV data, drop first line and convert entries from strings to date, float or integers
		data = CSV.parse(file	)[1..-1].map {|e| [Time.parse(e[0]), e[1].to_f, e[2].to_f, e[3].to_f, e[4].to_f, e[5].to_i, e[6].to_f, ]}

		HistoricalData.new(symbol, data)
	end

	def save(filename)
		File.open(filename, 'w') do |file|
			file.print(self.to_json)
		end
	end

	def to_json(*a)
		{
			symbol: @symbol,
			data: @data
		}.to_json(*a)
	end

	def self.from_json(string)
		hash = JSON.parse(string)
		new(hash["symbol"], hash["data"])
	end

	def self.from_file(filename)
		from_json(File.read(filename))
	end
end