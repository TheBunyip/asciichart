Gem::Specification.new do |s|
  s.name        = 'asciichart'
  s.version     = '1.0.0'
  s.date        = '2013-12-10'
  s.summary     = "asciichart"
  s.description = "Renders data series as an ASCII-style bar chart"
  s.authors     = ["Ben Miller"]
  s.email       = 'benito.m@gmail.com'
  s.files       = ["lib/asciichart.rb"]
  s.test_files  = ["spec/asciichart_spec.rb"]
  s.homepage    = ''
  s.license     = 'MIT'
  s.add_runtime_dependency "colorize"
  s.add_development_dependency "rspec"
end