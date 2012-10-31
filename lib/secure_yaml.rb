require 'secure_yaml/loader'
require 'secure_yaml/cipher'

module SecureYaml

  ENCRYPTED_PROPERTY_WRAPPER_ID = 'ENC'

  DEFAULT_SECRET_KEY_PROP_NAME = 'PROPERTIES_ENCRYPTION_PASSWORD'

  def self.load(yaml_file, opts = {})
    opts[:secret_key_property_name] ||= DEFAULT_SECRET_KEY_PROP_NAME
    opts[:decryption_algorithm] ||= Cipher.new

    yaml_loader(opts[:decryption_algorithm], retrieve_secret_key(opts[:secret_key_property_name])).load(yaml_file)
  end

  def self.parse(yaml, opts = {})
    load(StringIO.new(yaml), opts)
  end

  private

  def self.retrieve_secret_key(secret_key_prop_name)
    secret_key = ENV[secret_key_prop_name]
    raise "#{secret_key_prop_name} env property not found" if secret_key.nil?
    secret_key
  end

  def self.yaml_loader(decryption_algorithm, secret_key)
    Loader.new(YamlDecrypter.new(decryption_algorithm, secret_key))
  end

end
