require './historical_data'
require './n_day_performances'

@y = HistoricalData.from_file('./data/SP500')
@x = NDayPerformances.new(@y, 365*20)
i = @x.best_case_performances.map{|e| e[2]}.each_with_index.min[1]
puts @x.best_case_performances[i]