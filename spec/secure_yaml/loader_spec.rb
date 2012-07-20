require 'spec_helper'

describe 'Loader' do

  before(:each) do
    @encrypted_yaml = {prop: 'encrypted'}
    @decrypted_yaml = {prop: 'decrytped'}
    @decrypter = double(SecureYaml::YamlDecrypter)
    SecureYaml::YamlDecrypter.stub(:new).and_return(@decrypter)
  end

  it 'should load decrypted yaml file' do
    YAML.stub(:load).and_return(@encrypted_yaml)
    @decrypter.stub(:decrypt).with(@encrypted_yaml).and_return(@decrypted_yaml)

    yaml = SecureYaml::Loader.new('').load(double(File))

    yaml.should == @decrypted_yaml
  end

end