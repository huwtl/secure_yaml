require 'spec_helper'

describe 'Yaml decrypter' do

  before(:each) do
    @secret_key = 'abc12345678'
    @cipher = double(SecureYaml::Cipher)
    @decrypter = SecureYaml::YamlDecrypter.new(@cipher, @secret_key)
    @decrypted_result = 'decrypted data'
    @plain_text = 'some plain text'
  end

  it 'should decrypt encoded values in plain strings' do
    encrypted_data = 'encrypted data'
    @cipher.stub(:decrypt).with(@secret_key, encrypted_data).and_return(@decrypted_result)
    hash = {:encrypted_prop => "ENC(#{encrypted_data})", :plain_prop => @plain_text}
    data = @decrypter.decrypt(hash.to_yaml)
    YAML.load(data).should == {:encrypted_prop => @decrypted_result, :plain_prop => @plain_text}
  end

  it 'should decrypt only marked encrypted properties' do
    encrypted_data = 'encrypted data'
    @cipher.stub(:decrypt).with(@secret_key, encrypted_data).and_return(@decrypted_result)

    data = @decrypter.decrypt({:encrypted_prop => "ENC(#{encrypted_data})", :plain_prop => @plain_text})

    data.should == {:encrypted_prop => @decrypted_result, :plain_prop => @plain_text}
  end

  it 'should decrypt encrypted properties containing parentheses' do
    encrypted_prop_with_param = 'encrypted )data'
    @cipher.stub(:decrypt).with(@secret_key, encrypted_prop_with_param).and_return(@decrypted_result)

    data = @decrypter.decrypt({:encrypted_prop => "ENC(#{encrypted_prop_with_param})"})

    data.should == {:encrypted_prop => @decrypted_result}
  end

  it 'should ignore any encrypted properties in unexpected formats' do
    unexpected_formats = {:unexpected_1 => 'ENC(text', :unexpected_2 => 'ENCtext)', :unexpected_3 => 'EN(text)'}

    data = @decrypter.decrypt(unexpected_formats)

    data.should == unexpected_formats
  end

  it 'should recursively encrypt nested properties' do
    @cipher.stub(:decrypt).and_return(@decrypted_result)

    data = @decrypter.decrypt({:parent_prop => {:nested_prop => 'ENC(text)', :parent_prop_2 => {:nested_prop_2 => 'ENC(text)'}}})

    data.should == {:parent_prop => {:nested_prop => @decrypted_result, :parent_prop_2 => {:nested_prop_2 => @decrypted_result}}}
  end

  it 'should decrypt encrypted properties of array elements' do
    encrypted_data = 'encrypted data'
    @cipher.stub(:decrypt).and_return(@decrypted_result)

    data = @decrypter.decrypt([{:encrypted_prop => "ENC(#{encrypted_data})"}])

    data.should == [{:encrypted_prop => @decrypted_result}]
  end

  it 'should ignore any property of non-string type' do
    numeric_prop = {:numeric => 1}

    data = @decrypter.decrypt(numeric_prop)

    data.should == numeric_prop
  end

end
