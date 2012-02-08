# -*- encoding: utf-8 -*-
require File.expand_path('../lib/csv_shaper/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Paul Springett"]
  gem.email         = ["paul@springett.me"]
  gem.description   = %q{CSV template builder}
  gem.summary       = %q{Creates a CSV file from objects, with Rails support}
  gem.homepage      = "http://github.com/paulspringett/csv_shaper"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "csv_shaper"
  gem.require_paths = ["lib"]
  gem.version       = CsvShaper::VERSION

  gem.add_dependency 'activesupport', '>= 3.0.0'
  gem.add_dependency 'faster_csv', '~> 1.5.4'

  gem.add_dependency 'rspec'

end
