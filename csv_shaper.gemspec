# -*- encoding: utf-8 -*-
require File.expand_path('../lib/csv_shaper/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Paul Springett"]
  gem.email         = ["paul@springett.me"]

  gem.summary       = %q{Beautiful DSL for creating CSV output in Ruby & Rails}
  gem.description   = %q{
    Creating CSV files in Ruby is painful! CSV Shaper makes life easier! It's
    ideal for converting database backed models with attributes into CSV output.
    It can be used without Rails, but works great with ActiveRecord models and even
    comes with support for it's own template handling.
  }

  gem.licenses      = ['MIT']

  gem.homepage      = "http://github.com/paulspringett/csv_shaper"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "csv_shaper"
  gem.require_paths = ["lib"]
  gem.version       = CsvShaper::VERSION

  gem.add_dependency 'activesupport', '>= 3.0.0'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rake'
end
