# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "yaml_encryption/version"

Gem::Specification.new do |s|
  s.name        = "yaml_encryption"
  s.version     = YamlEncryption::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Huw Lewis"]
  s.email       = ["huwtlewis@gmail.com"]
  s.homepage    = "https://github.com/qmg-hlewis/yaml_encryption"
  s.summary     = %q{encryption protection for sensitive yaml properties}
  s.description = %q{encryption protection for sensitive yaml properties}

  s.rubyforge_project = "yaml_encryption"

  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  #s.add_dependency "", ">= VERSION"
  
  s.add_development_dependency 'rspec', "~> 2.10.0"
  s.add_development_dependency 'rspec-mocks', "~> 2.10.1"
  s.add_development_dependency 'bundler', "~> 1.0.22"
  s.add_development_dependency 'rake', ">= 0.9.2.2"

end
