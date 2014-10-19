class NDayPerformances

	attr_reader :historical_data, :n

	def initialize(historical_data, n)
		@historical_data = historical_data
		@n = n
	end
	
	def best_case_performances
		@best_case_performances ||= calculate_best_case_performances
	end

	private

	def calculate_best_case_performances
		latest_date = historical_data.data[0][0]
		best_case_performances = Array.new

		# Look at all entries starting with the oldest
		i = historical_data.data.size - 1
		while i >= 0 # just to be sure

			# Variable to store the incumbent
			max_return = nil
			max_j = nil

			# look at the following days until we reach the limit of n days
			j = i - 1
			while j >= 0 && (historical_data.data[j][0] - historical_data.data[i][0]) / (60*60*24) <= n
				# Calculate performance on day j
				n_days = ((historical_data.data[j][0] - historical_data.data[i][0]) / (60*60*24)).to_i
				period_return = historical_data.data[j][6] / historical_data.data[i][6] - 1
				annual_return = (1 + period_return) ** (365.0 / n_days) - 1

				# Update incumbent
				if max_return.nil? || annual_return > max_return
					max_return = annual_return
					max_j = j
				end

				j -= 1
			end

			# Save the best performance for the n day period starting at i
			# Format: Day where bought, day where optimally sold, optimal return
			best_case_performances << [historical_data.data[i][0], historical_data.data[max_j][0], max_return]

			# End loop if the most current date was reached
			if j <= 0
				return best_case_performances
			end
			i -= 1
		end
	end

end