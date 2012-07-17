require 'spec_helper'
require './lib/secure_yaml/yaml_decryption'

describe 'Yaml decryption' do

  before(:all) do
    @secret_key = 'abc12345678'
    @cipher = double(SecureYaml::Cipher)
    @yaml_decryption = SecureYaml::YamlDecryption.new(@secret_key, @cipher)
    @decrypted_result = 'decrypted data'
    @plain_text = 'some plain text'
  end

  it 'should decrypt only marked encrypted properties' do
    encrypted_data = 'encrypted data'
    @cipher.stub(:decrypt).with(@secret_key, encrypted_data).and_return(@decrypted_result)

    data = @yaml_decryption.decrypt({:encrypted_prop => "ENC(#{encrypted_data})", :plain_prop => @plain_text})

    data.should == {:encrypted_prop => @decrypted_result, :plain_prop => @plain_text}
  end

  it 'should decrypt encrypted properties containing parentheses' do
    encrypted_prop_with_param = 'encrypted )data'
    @cipher.stub(:decrypt).with(@secret_key, encrypted_prop_with_param).and_return(@decrypted_result)

    data = @yaml_decryption.decrypt({:encrypted_prop => "ENC(#{encrypted_prop_with_param})"})

    data.should == {:encrypted_prop => @decrypted_result}
  end

  it 'should ignore any encrypted properties in unexpected formats' do
    unexpected_formats = {:unexpected_1 => 'ENC(text', :unexpected_2 => 'ENCtext)', :unexpected_3 => 'EN(text)'}

    data = @yaml_decryption.decrypt(unexpected_formats)

    data.should == unexpected_formats
  end

  it 'should recursively encrypt nested properties' do
    @cipher.stub(:decrypt).and_return(@decrypted_result)

    data = @yaml_decryption.decrypt({:parent_prop => {:nested_prop => 'ENC(text)', :parent_prop_2 => {:nested_prop_2 => 'ENC(text)'}}})

    data.should == {:parent_prop => {:nested_prop => @decrypted_result, :parent_prop_2 => {:nested_prop_2 => @decrypted_result}}}
  end

  it 'should ignore any property of non-string type' do
    numeric_prop = {:numeric => 1}

    data = @yaml_decryption.decrypt(numeric_prop)

    data.should == numeric_prop
  end

end