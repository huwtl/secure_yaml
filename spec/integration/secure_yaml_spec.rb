require 'spec_helper'

describe 'SecureYaml' do

  before(:each) do
    @secret_key = 'secret'
    ENV[SecureYaml::DEFAULT_SECRET_KEY_PROP_NAME] = @secret_key
    @test_yaml_file = File.open('spec/fixtures/test.yml')
  end

  it 'should load decrypted yaml file using default decryption algorithm' do
    yaml = SecureYaml::load(@test_yaml_file)

    yaml.should == {:plain_prop => '1234', :encrypted_prop => 'secret-text'}
  end

  it 'should load decrypted yaml file using custom decryption algorithm' do
    custom_decryption_algorithm = Class.new {
      def self.decrypt(secret_key, encrypted_data)
        "decrypted!"
      end
    }

    yaml = SecureYaml::load(@test_yaml_file, {:decryption_algorithm => custom_decryption_algorithm})

    yaml.should == {:plain_prop => '1234', :encrypted_prop => 'decrypted!'}
  end

end