require 'openssl'
require 'digest/sha2'
require 'base64'
require 'yaml'

def decrypt(encrypted_data)
  aes = OpenSSL::Cipher.new("AES-256-CFB")
  aes.decrypt
  aes.key = Digest::SHA2.new(256).digest(@passphrase)
  aes.update(Base64.strict_decode64(encrypted_data)) + aes.final
end

def decrypt_yaml(yaml)
  case yaml
    when Hash
      yaml.each_with_object({}) {|(key, value), new_hash| new_hash[key] = decrypt_yaml(value)}
    when String
      yaml.gsub(/^ENC\((.*)\)$/) {decrypt($1)}
    else
      yaml
  end
end

def encrypt(plain_data)
  aes = OpenSSL::Cipher.new("AES-256-CFB")
  aes.encrypt
  aes.key = Digest::SHA2.new(256).digest(@passphrase)
  encrypted_data = Base64.strict_encode64(aes.update(plain_data) + aes.final)
end

@passphrase = ENV["PROP_PASSPHRASE"]
raise "PROP_PASSPHRASE env property not found" if @passphrase.nil?

p decrypt_yaml(YAML::load(File.open('test.yml')))

