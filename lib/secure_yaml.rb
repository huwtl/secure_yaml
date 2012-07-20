require 'secure_yaml/loader'

module SecureYaml

  ENCRYPTED_PROPERTY_WRAPPER_ID = 'ENC'

  DEFAULT_SECRET_KEY_PROP_NAME = 'PROPERTIES_ENCRYPTION_PASSWORD'

  def self.load(yaml_file, secret_key_prop_name = DEFAULT_SECRET_KEY_PROP_NAME)
    SecureYaml::Loader.new(secret_key(secret_key_prop_name)).load(yaml_file)
  end

  private

  def self.secret_key(secret_key_prop_name)
    secret_key = ENV[secret_key_prop_name]
    raise "#{secret_key_prop_name} env property not found" if secret_key.nil?
    secret_key
  end

end
