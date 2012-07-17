require './lib/secure_yaml/yaml_decryption'

module SecureYaml

  class SecureYaml

    def initialize(yaml_decryption = YamlDecryption.new(@passphrase))
      @passphrase = ENV["PROPERTIES_ENCRYPTION_PASSWORD"]
      raise "PROPERTIES_ENCRYPTION_PASSWORD env property not found" if @passphrase.nil?
      @yaml_decryption = yaml_decryption
    end

    def load(yaml_file)
      p @yaml_decryption.decrypt(YAML::load(yaml_file))
    end

  end

end
