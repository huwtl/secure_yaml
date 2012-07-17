require 'rspec'
require 'rspec/mocks'

RSpec.configure do |conf|
  conf.include RSpec::Mocks::ExampleMethods
end