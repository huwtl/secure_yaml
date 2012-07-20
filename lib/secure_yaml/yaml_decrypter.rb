require 'yaml'
require 'secure_yaml/cipher'

module SecureYaml

  class YamlDecrypter

    def initialize(secret_key, cipher = Cipher.new)
      @cipher = cipher
      @secret_key = secret_key
    end

    def decrypt(yaml)
      case yaml
        when Hash
          yaml.inject({}) {|new_hash, (key, value)| new_hash[key] = decrypt(value); new_hash}
        when String
          yaml.gsub(/^#{ENCRYPTED_PROPERTY_WRAPPER_ID}\((.*)\)$/) {@cipher.decrypt(@secret_key, $1)}
        else
          yaml
      end
    end

  end

end
