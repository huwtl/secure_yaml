require 'openssl'
require 'digest/sha2'
require 'base64'

module SecureYaml
  
  class Cipher

    def encrypt(secret_key, plain_data)
      cipher = create_cipher(secret_key)
      cipher.encrypt
      Base64.strict_encode64(cipher.update(plain_data) + cipher.final)
    end

    def decrypt(secret_key, encrypted_data)
      cipher = create_cipher(secret_key)
      cipher.decrypt
      cipher.update(Base64.strict_decode64(encrypted_data)) + cipher.final
    end
    
    private

    def create_cipher(secret_key)
      cipher = OpenSSL::Cipher.new("AES-256-CFB")
      cipher.encrypt
      cipher.key = Digest::SHA2.new(256).digest(secret_key)
      cipher
    end

  end

end
