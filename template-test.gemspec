# -*- encoding: utf-8 -*-
require File.expand_path('../lib/template-test/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ruben Jenster"]
  gem.email         = ["r@j5r.eu"]
  gem.description   = %q{Provides a simple DSL to test the rendering of HTML templates
                          defined in ERB or HAML using XPATH expressions}
  gem.summary       = %q{Simple DSL for HTML template (ERB,HAML) testing}
  gem.homepage      = "https://github.com/r10r/template-test"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "template-test"
  gem.require_paths = ["lib"]
  gem.version       = Template::Test::VERSION
  gem.add_dependency 'rspec'
  gem.add_dependency 'nokogiri'
  gem.add_dependency 'haml'
  gem.add_development_dependency 'autotest'
  gem.add_development_dependency 'autotest-fsevent'
  gem.add_development_dependency 'autotest-growl'
end
