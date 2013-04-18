require "secure_yaml"

module SecureYaml

  class PropertyEncryptionApplication

    def execute(command_line_args)

      raise "USAGE: encrypt_property_for_yaml encrypt|decrypt <SECRET_KEY> <PROPERTY_VALUE_TO_ENCRYPT>" unless command_line_args.length == 3

      mode = command_line_args[0]
      secret_key = command_line_args[1]
      plain_text = command_line_args[2]

      if mode == 'encrypt'
            puts "#{ENCRYPTED_PROPERTY_WRAPPER_ID}(#{Cipher.new.encrypt(secret_key, plain_text)})"
      else
            puts Cipher.new.decrypt(secret_key, plain_text)
      end
    end

  end

end