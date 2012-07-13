
module YamlEncryption

  class YamlEncryption

    def initialize()
      @passphrase = ENV["PROPERTIES_ENCRYPTION_PASSWORD"]
      raise "PROPERTIES_ENCRYPTION_PASSWORD env property not found" if @passphrase.nil?
    end

    def load(yaml_file)
      p decrypt_yaml(YAML::load(File.open('test.yml')))
    end

  end

end
