require 'spec_helper'

describe 'Cipher' do

  before(:each) do
    @cipher = SecureYaml::Cipher.new
    @secret_key = "abc12345678"
    @plain_text = "some plain text to encrypt"
  end

  it 'should decrypt encrypted data' do
    encrypted = @cipher.encrypt(@secret_key, @plain_text)

    decrypted = @cipher.decrypt(@secret_key, encrypted)

    encrypted.should_not == @plain_text
    decrypted.should == @plain_text
  end

end