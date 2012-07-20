require 'rspec'
require 'rspec/mocks'

require 'secure_yaml'
require 'secure_yaml/cli/property_encryption_application'

RSpec.configure do |conf|
  conf.include RSpec::Mocks::ExampleMethods
end