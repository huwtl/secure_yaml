require 'secure_yaml/yaml_decrypter'

module SecureYaml

  class Loader

    def initialize(secret_key)
      @decrypter = YamlDecrypter.new(secret_key)
    end

    def load(yaml_file)
      @decrypter.decrypt(YAML::load(yaml_file))
    end

  end

end
