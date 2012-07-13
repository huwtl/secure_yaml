require 'yaml'

module YamlEncryption

  class YamlDecryption

    def decrypt(yaml)
      case yaml
        when Hash
          yaml.each_with_object({}) {|(key, value), new_hash| new_hash[key] = decrypt_yaml(value)}
        when String
          yaml.gsub(/^ENC\((.*)\)$/) {decrypt($1)}
        else
          yaml
      end
    end

  end

end
