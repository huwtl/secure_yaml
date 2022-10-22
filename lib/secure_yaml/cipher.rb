require 'openssl'
require 'digest/sha2'
require 'base64'

module SecureYaml
  
  class Cipher

    def encrypt(secret_key, plain_data)
      cipher = create_cipher(secret_key, :encrypt)
      strip_newline_chars_from_base64(Base64.encode64(cipher.update(plain_data) + cipher.final))
    end

    def decrypt(secret_key, encrypted_data)
      cipher = create_cipher(secret_key, :decrypt)
      cipher.update(Base64.decode64(encrypted_data)) + cipher.final
    end
    
    private

    def create_cipher(secret_key, method)
      cipher = OpenSSL::Cipher.new("AES-256-CFB")
      cipher.__send__(method)
      cipher.key = Digest::SHA2.new(256).digest(secret_key)
      cipher
    end

    def strip_newline_chars_from_base64(base64)
      base64.gsub("\n", '')
    end

  end

end
