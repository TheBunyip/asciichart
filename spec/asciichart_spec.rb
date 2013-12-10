require_relative '../lib/asciichart'
require_relative './spec_helper'

describe 'graph' do
	it 'can be created' do
		graph = AsciiChart.new 10
		expect(graph.num_series).to eq(0)
		expect(graph.max_x).to eq(0)
		expect(graph.min_y).to eq(0)
		expect(graph.max_y).to eq(0)
	end

	it 'can have a series added' do
		graph = AsciiChart.new 2
		graph.add_series([10, 20, 30])
		graph.add_series([15, 15, 10])
		expect(graph.num_series).to eq(2)
		expect(graph.max_x).to eq(3)
		expect(graph.min_y).to eq(0)
		expect(graph.max_y).to eq(30)
	end

	it 'renders correctly' do
		graph = AsciiChart.new 2
		graph.add_series([10, 20])
		expect(graph.render).to eq(
			"----------\r\n" +
			"|        |\r\n" +
			"|     #  |\r\n" +
			"|  #  #  |\r\n" +
			"----------\r\n\r\n" +
			"Series 0"
		)
	end

end