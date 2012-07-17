require 'yaml'
require './lib/secure_yaml/cipher'

module SecureYaml

  class YamlDecryption

    def initialize(secret_key, cipher = Cipher.new)
      @cipher = cipher
      @secret_key = secret_key
    end

    def decrypt(yaml)
      case yaml
        when Hash
          yaml.each_with_object({}) {|(key, value), new_hash| new_hash[key] = decrypt(value)}
        when String
          yaml.gsub(/^ENC\((.*)\)$/) {@cipher.decrypt(@secret_key, $1)}
        else
          yaml
      end
    end

  end

end
