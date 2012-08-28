require 'spec_helper'

describe 'SecureYaml' do

  before(:each) do
    @secret_key = 'secret key'
    @yaml = {:prop => 'test'}

    @default_decryption_algorithm = double(SecureYaml::Cipher)
    SecureYaml::Cipher.stub(:new).and_return(@default_decryption_algorithm)


    @loader = double(SecureYaml::Loader)
    @yaml_decrypter = double(SecureYaml::YamlDecrypter)
    SecureYaml::Loader.stub(:new).with(@yaml_decrypter).and_return(@loader)
    @loader.stub(:load).and_return(@yaml)
  end

  it 'should load decrypted yaml file' do
    ENV[SecureYaml::DEFAULT_SECRET_KEY_PROP_NAME] = @secret_key
    SecureYaml::YamlDecrypter.stub(:new).with(@default_decryption_algorithm, @secret_key).and_return(@yaml_decrypter)

    yaml = SecureYaml::load(double(File))

    yaml.should == @yaml
  end

  it 'should raise error on load if secret key env property not set' do
    ENV[SecureYaml::DEFAULT_SECRET_KEY_PROP_NAME] = nil

    expect {SecureYaml::load(double(File))}.to raise_error
  end

  it 'should allow use of custom secret key property name' do
    custom_secret_key_prop_name = 'CUSTOMER_SECRET_KEY_PROP_NAME'
    ENV[custom_secret_key_prop_name] = @secret_key
    SecureYaml::YamlDecrypter.stub(:new).with(@default_decryption_algorithm, @secret_key).and_return(@yaml_decrypter)

    yaml = SecureYaml::load(double(File), {:secret_key_property_name => custom_secret_key_prop_name})

    yaml.should == @yaml
  end

  it 'should allow use of custom decryption algorithm' do
    ENV[SecureYaml::DEFAULT_SECRET_KEY_PROP_NAME] = @secret_key
    custom_decryption_algorithm = Class.new {
      def self.decrypt(secret_key, encrypted_data)
        "decrypt data here from #{secret_key} and #{encrypted_data}"
      end
    }
    SecureYaml::YamlDecrypter.stub(:new).with(custom_decryption_algorithm, @secret_key).and_return(@yaml_decrypter)

    yaml = SecureYaml::load(double(File), {:decryption_algorithm => custom_decryption_algorithm})

    yaml.should == @yaml
  end

end