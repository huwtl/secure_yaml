require 'secure_yaml/loader'
require 'secure_yaml/cipher'

module SecureYaml

  ENCRYPTED_PROPERTY_WRAPPER_ID = 'ENC'

  DEFAULT_SECRET_KEY_PROP_NAME = 'PROPERTIES_ENCRYPTION_PASSWORD'

  def self.load(yaml_file, secret_key_prop_name = DEFAULT_SECRET_KEY_PROP_NAME, &decryption_block)
    decryption_algorithm = block_given? ? custom_decryption_algorithm(decryption_block) : Cipher.new

    yaml_loader(decryption_algorithm, retrieve_secret_key(secret_key_prop_name)).load(yaml_file)
  end

  private

  def self.retrieve_secret_key(secret_key_prop_name)
    secret_key = ENV[secret_key_prop_name]
    raise "#{secret_key_prop_name} env property not found" if secret_key.nil?
    secret_key
  end

  def self.custom_decryption_algorithm(decryption_block)
    Class.new {
      def initialize(decryption_block)
        @decryption_block = decryption_block
      end

      def decrypt(secret_key, encrypted_data)
        @decryption_block.call(secret_key, encrypted_data)
      end
    }.new(decryption_block)
  end

  def self.yaml_loader(decryption_algorithm, secret_key)
    Loader.new(YamlDecrypter.new(decryption_algorithm, secret_key))
  end

end
