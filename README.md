### Overview

The storage of sensitive information (such as usernames and passwords) within source control is commonly avoided due to security concerns, i.e. an untrusted person gaining access to your code, would have access to your production database password.

This library attempts to address this concern by allowing sensitive information to be stored in YAML files in an encrypted form. Inspired by [Jasypt](http://www.jasypt.org/encrypting-configuration.html).
<br />

### Usage

<strong>1) Install the secure_yaml gem</strong>

```
> gem install secure_yaml
```
<br />

<strong>2) Encrypt your sensitive properties, and copy them into your YAML file</strong>

The gem provides a simple command line utility called ```encrypt_property_for_yaml``` that prints out the encrypted form of a plain text property.

```
USAGE: encrypt_property_for_yaml encrypt|decrypt <SECRET_KEY> <PROPERTY_VALUE_TO_ENCRYPT>
```

For example:

```
> encrypt_property_for_yaml abc12345678 jdbc:mysql://11.22.33.44:3306/prod
ENC(1BVzrT18dxWisIKUPkq9k0SB/aKcT70VawodxucI)  <-- copy this value into your YAML file
```

When completed, your YAML file might look something like the following:

```
production:
  db_adapter: mysql
  db_url: ENC(1BVzrT18dxWisIKUPkq9k0SB/aKcT70VawodxucI)
  db_username: ENC(4BEzrT18dxdisIKFPkw7k0SB/hKcT80VawodxuwT)
  db_password: ENC(2BVzrQ79deWisIKUPkq9k8SB/aKcT74CawoExuiP)
  pool: 5
  timeout: 5000

```

Note:
* your YAML file can consist of a combination of plain text and encrypted property values
* the encrypted properties can be positioned within the YAML at any nested depth.

<br />

<strong>3) Supply the secret key (used by the encryption process in step 2) as an environmental property to your running app</strong>

By default, the expected name of this environmental property is 'PROPERTIES_ENCRYPTION_PASSWORD', but can be overridden if required.

```
export PROPERTIES_ENCRYPTION_PASSWORD=abc12345678; ruby app.rb
```

<strong>*** The value of the secret key must NOT be submitted to source control. Knowing the secret key allows a person to easily decrypt your properties.</strong>
<br />
<br />

<strong>4) Load and use the decrypted version of your YAML file within your app</strong>

```ruby
require 'secure_yaml'

decrypted_yaml = SecureYaml::load(File.open('database.yml'))

# Alternatively, to override the default secret key environmental property name:
decrypted_yaml = SecureYaml::load(File.open('database.yml'), {
  :secret_key_property_name => 'NEW_SECRET_KEY_PROPERTY_NAME'
})
```

<br />
<strong>4) Parse and use the decrypted version of a YAML string within your app</strong>

```ruby
require 'secure_yaml'

decrypted_yaml = SecureYaml::parse("some correctly formatted yaml text")
```
<br />

### Customising decryption

The default decryption method applied by this library when loading a YAML file is [AES-256-CFB](http://en.wikipedia.org/wiki/Advanced_Encryption_Standard).
However, if you wish to, you can specify your own custom decryption algorithm:

```ruby
require 'secure_yaml'

custom_decryption_algorithm = Class.new {
  def self.decrypt(secret_key, encrypted_data)
    "your decrypted data returned here"
  end
}

decrypted_yaml = SecureYaml::load(File.open('database.yml'), {
  :decryption_algorithm => custom_decryption_algorithm
})
```


