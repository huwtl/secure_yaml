require 'secure_yaml/yaml_decrypter'

module SecureYaml

  class Loader

    def initialize(yaml_decrypter)
      @yaml_decrypter = yaml_decrypter
    end

    def load(yaml_file)
      @yaml_decrypter.decrypt(YAML::load(yaml_file))
    end

  end

end
