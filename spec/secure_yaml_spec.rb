require 'spec_helper'

describe 'SecureYaml' do

  before(:each) do
    @secret_key = 'secret key'
    @yaml = {:prop => 'test'}
    loader = double(SecureYaml::Loader)
    loader.stub(:load).and_return(@yaml)
    SecureYaml::Loader.stub(:new).with(@secret_key).and_return(loader)
  end

  it 'should load decrypted yaml file' do

    ENV[SecureYaml::DEFAULT_SECRET_KEY_PROP_NAME] = @secret_key

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

    yaml = SecureYaml::load(double(File), custom_secret_key_prop_name)

    yaml.should == @yaml
  end

end