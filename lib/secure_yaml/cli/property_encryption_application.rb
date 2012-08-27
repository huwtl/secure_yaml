require "secure_yaml"

module SecureYaml

  class PropertyEncryptionApplication

    def execute(command_line_args)

      raise "USAGE: encrypt_property_for_yaml <SECRET_KEY> <PROPERTY_VALUE_TO_ENCRYPT>" unless command_line_args.length == 2

      secret_key = command_line_args[0]
      plain_text = command_line_args[1]

      puts "#{ENCRYPTED_PROPERTY_WRAPPER_ID}(#{Cipher.new.encrypt(secret_key, plain_text)})"
    end

  end

end