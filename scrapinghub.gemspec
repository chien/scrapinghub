# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scrapinghub/version'

Gem::Specification.new do |gem|
  gem.name          = "scrapinghub"
  gem.version       = Scrapinghub::VERSION
  gem.authors       = ["Emil Ahlback", "Chien Kuo"]
  gem.email         = ["e.ahlback@gmail.com", "chien.cc.kuo@gmail.com"]
  gem.description   = %q{Simple interface to Scrapinghub's API}
  gem.summary       = %q{Just a Ruby wrapper for the Scrapinghub API, see docs at: http://help.scrapinghub.com/api.html}
  gem.homepage      = "https://github.com/chien/scrapinghub"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'json'
end
