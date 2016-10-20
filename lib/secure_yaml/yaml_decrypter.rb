require 'yaml'

module SecureYaml

  class YamlDecrypter

    def initialize(decryption_algorithm, secret_key)
      @decryption_algorithm = decryption_algorithm
      @secret_key = secret_key
    end

    def decrypt(yaml)
      case yaml
        when Hash
          yaml.inject({}) {|new_hash, (key, value)| new_hash[key] = decrypt(value); new_hash}
        when String
          yaml.gsub(/\b#{ENCRYPTED_PROPERTY_WRAPPER_ID}\((.*)\)(?:\b|$)/) {@decryption_algorithm.decrypt(@secret_key, $1)}
        when Array
          yaml.map {|element| decrypt(element)}
        else
          yaml
      end
    end

  end

end
