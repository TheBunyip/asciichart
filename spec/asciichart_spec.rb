require_relative './asciichart'
require_relative './spec_helper'

describe 'graph' do
	before(:each) do
		@graph = AsciiChart.new 10, 20, 110, 220
	end

	it 'can be created' do
		expect(@graph.xstep).to eq(0.2)
		expect(@graph.ystep).to eq(0.1)
		expect(@graph.xrange).to eq(100)
		expect(@graph.yrange).to eq(200)
	end

	it 'can have a series added' do
		@graph.add_series([10, 20, 30, 40, 50])
		expect(@graph.num_series).to eq(1)
	end

end