require 'spec_helper'

describe 'Property encryption command line interface' do

  before(:each) do
    @secret_key = 'secret key'
    @plain_text = 'text to encrypt'
    @encrypted_text = 'encrypted text'
  end

  it 'should print encrypted property value for given secret key and plain text' do
    cipher = double(SecureYaml::Cipher)
    cipher.stub(:encrypt).with(@secret_key, @plain_text).and_return(@encrypted_text)
    SecureYaml::Cipher.stub(:new).and_return(cipher)

    $stdout.should_receive(:puts).with("#{SecureYaml::ENCRYPTED_PROPERTY_WRAPPER_ID}(#{@encrypted_text})")

    SecureYaml::PropertyEncryptionApplication.new.execute(["encrypt", @secret_key, @plain_text])
  end

  it 'should raise error unless secret key and plain text have been included as command line args' do
    expect {SecureYaml::PropertyEncrypterApplication.new.execute([])}.to raise_error
    expect {SecureYaml::PropertyEncrypterApplication.new.execute([@secret_key])}.to raise_error
  end

  it 'should raise error if too many comand line args' do
    expect {SecureYaml::PropertyEncryptionApplication.new.execute(["encrypt", @secret_key, @plain_text, 'unexpected'])}.to raise_error
  end

end
