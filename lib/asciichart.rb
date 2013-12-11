require 'colorize'

class AsciiChart
	attr_reader :max_x, :min_y, :max_y, :series, :colourise
	attr_writer :num_rows, :bar_thickness, :bar_spacing

	def initialize
		@num_rows = 10
		@bar_thickness = 1
		@bar_spacing = 2
		@colourise = false
		@series = []
		@max_x = 0
		@min_y = 0
		@max_y = 0
		@@colours = %w{red yellow green cyan magenta blue}.map(&:to_sym)
	end

	def add_series(series, name=nil)
		@series << {
			values: series, 
			colour: pick_colour(@series.length), 
			name: name ? name.capitalize : "Series #{@series.length}"
		}
		@min_y = [series.min, @min_y].min
		@max_y = [series.max, @max_y].max
		@max_x = [series.length, @max_x].max
	end

	def num_series
		@series.length
	end

	def render
		# we need one column for each series up the maximum 
		# length of any one series, plus one for padding
		width = ((num_series + @bar_spacing) * @max_x * @bar_thickness) + @bar_spacing
		step = (@max_y - @min_y) / @num_rows.to_f
		y_top = @max_y.to_f
		
		bitmap = '-' * (width + 2)
		bitmap += "\r\n|" + (' ' * width) + '|'

		@num_rows.times do
			bitmap += "\r\n|" + (' ' * @bar_spacing)
			
			# loop on each distinct time/x value
			@max_x.times do |x|
				@series.each do |s|
					bitmap += get_ascii_char(s, x, (y_top - step)..y_top) * @bar_thickness
				end
				bitmap += ' ' * @bar_spacing
			end
			bitmap += '|'
			y_top = (y_top - step).round(2)
		end
		bitmap += "\r\n" + ('-' * (width + 2))

		# the legend
		bitmap += "\r\n"
		@series.each do |s|
			bitmap += "\r\n" + (@colourise ? s[:name].send(s[:colour]) : s[:name])
		end
		bitmap
	end

	def colourise=(value)
		if value and ENV['OS'] == 'Windows_NT'
			if Gem::Specification::find_all_by_name('win32console').any?
				@colourise = true
				require 'win32console'
			else
				raise "Cannot colourise a chart without the 'win32console' gem installed"
			end
		else
			@colourise = value
		end
	end

private
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
		@colourise ? c.send(series[:colour]) : c
	end

	def pick_colour(index)
		@@colours[index % @@colours.length]
	end
end

