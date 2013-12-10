require 'colorize'

class AsciiChart
	attr_reader :maxx, :miny, :maxy, :series

	def initialize(rows=20)
		@rows = rows
		@series = []
		@maxx = 0
		@miny = 0
		@maxy = 0
		@@colours = %w{red green blue}.map(&:to_sym)
	end

	def add_series(series, name=nil)
		@series << {
			values: series, 
			colour: pick_colour(@series.length), 
			name: name ? name.capitalize : "Series #{@series.length}"
		}
		@miny = [series.min, @miny].min
		@maxy = [series.max, @maxy].max
		@maxx = [series.length, @maxx].max
	end

	def num_series
		@series.length
	end

	def render
		# we need one column for each series up the maximum 
		# length of any one series, plus one for padding
		width = ((num_series + 2) * @maxx) + 2
		step = (@maxy - @miny) / @rows.to_f
		y_top = @maxy.to_f
		
		bitmap = '-' * (width + 2)
		bitmap += "\r\n|" + (' ' * width) + '|'

		@rows.times do
			bitmap += "\r\n|  "
			
			# loop on each distinct time/x value
			@maxx.times do |x|
				@series.each do |s|
					bitmap += get_ascii_char(s, x, (y_top - step)..y_top)
				end
				bitmap += '  '
			end
			bitmap += '|'
			y_top = (y_top - step).round(2)
		end
		bitmap += "\r\n" + ('-' * (width + 2))

		# the legend
		bitmap += "\r\n"
		@series.each do |s|
			bitmap += "\r\n" + s[:name].send(s[:colour])
		end

		puts bitmap
	end

	def get_ascii_char(series, time, value_range)
		# returns an ascii character to represent the value-range for the given series at the given time
		# if the series does not have a high enough value at that time, we return ' '
		value = series[:values][time]
		if value and value >= value_range.max.to_f
			c = '#'
		elsif value and value > value_range.min.to_f
			c = '.'
		else
			c = ' '
		end
		c.send(series[:colour])
	end

	def pick_colour(index)
		@@colours[index % @@colours.length]
	end



end

