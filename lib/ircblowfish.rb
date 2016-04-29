require "ircblowfish/version"
require "ircblowfish/base64"

require "base64"
require "openssl"
require "securerandom"

module IrcBlowfish
  def self.encrypt(msg, key)
    return encrypt_ecb(msg, key) if key =~ /^(?:old|ecb):/
    return encrypt_cbc(msg, key)
  end

  def self.decrypt(msg, key)
    return decrypt_ecb(msg, key) if key =~ /^(?:old|ecb):/
    return decrypt_cbc(msg, key)
  end

  def self.encrypt_ecb(msg, key)
    return msg if key.nil? or key == ''
    return msg if msg.nil? or msg == ''

    # Force encoding to binary in case of non-ascii messages
    plaintext = msg.dup.force_encoding 'BINARY'

    # Remove the ecb:/old: prefix if it's used
    key = key.sub %{^(?:old|ecb):}, ''

    # Create the Blowfish-CBC cipher
    cipher = OpenSSL::Cipher.new 'bf-ecb'
    cipher.encrypt
    cipher.key_len = key.length
    cipher.key = key
    cipher.padding = 0

    # Add null padding to make the length a multiple of 8
    plaintext += "\x00" * (8 - (plaintext.bytesize % 8))

    # Generate the IRC message with prefix
    '+OK ' + IrcBlowfish::Base64.encode(cipher.update(plaintext))
  end

  def self.decrypt_ecb(msg, key)
    return msg if key.nil? or key == ''
    return msg if msg.nil? or msg == ''

    # Ensure the message is a valid Blowfish-ECB message and remove the prefix
    ciphertext = msg.dup
    return msg unless ciphertext.sub! %r{^\+OK }, ''
    return msg if ciphertext[0] == '*' # Dump if this is actually a Blowfish-CBC message
    return '' if ciphertext == '' # I've seen some clients send "+OK " for null messages

    # Remove the ecb:/old: prefix if it's used
    key = key.sub %r{^(?:old|ecb):}, ''

    # Create the Blowfish-CBC cipher
    cipher = OpenSSL::Cipher.new 'bf-ecb'
    cipher.decrypt
    cipher.key_len = key.length
    cipher.key = key
    cipher.padding = 0

    # Decrypt the ciphertext and remove the trailing padding
    cipher.update(IrcBlowfish::Base64.decode(ciphertext)).sub! %r{\x00*$}, ''
  end

  def self.encrypt_cbc(msg, key)
    return msg if key.nil? or key == ''
    return msg if msg.nil? or msg == ''

    # Force encoding to binary in case of non-ascii messages
    plaintext = msg.dup.force_encoding 'BINARY'

    # Remove the cbc: prefix if it's used
    key = key.sub %r{^cbc:}, ''

    # Generate a random IV of length 8
    iv = random_iv 8

    # Create the Blowfish-CBC cipher
    cipher = OpenSSL::Cipher.new 'bf-cbc'
    cipher.encrypt
    cipher.key_len = key.length
    cipher.key = key
    cipher.padding = 0
    cipher.iv = iv

    # Add null padding to make the length a multiple of 8
    plaintext += "\x00" * (8 - (plaintext.bytesize % 8))

    # Generate the IRC message with prefix
    '+OK *' + ::Base64.encode64(iv + cipher.update(plaintext)).gsub!(/\n/, '')
  end

  def self.decrypt_cbc(msg, key)
    return msg if key.nil? or key == ''
    return msg if msg.nil? or msg == ''

    # Ensure the message is a valid Blowfish-CBC message and remove the prefix
    ciphertext = msg.dup
    return msg unless ciphertext.sub! %r{^\+OK \*}, ''

    # Remove the cbc: prefix if it's used
    key = key.sub %r{^cbc:}, ''

    # Decode the text to get the IV + ciphertext
    ciphertext = ::Base64.decode64 ciphertext

    iv = ciphertext[0,8]           # Extract the IV from the string
    ciphertext = ciphertext[8..-1] # Remove the IV from the string

    # Create the Blowfish-CBC cipher
    cipher = OpenSSL::Cipher.new 'bf-cbc'
    cipher.decrypt
    cipher.key_len = key.length
    cipher.key = key
    cipher.padding = 0
    cipher.iv = iv

    # Decrypt the ciphertext and remove the trailing padding
    cipher.update(ciphertext).sub! %r{\x00*$}, ''
  end

  private

  def self.random_iv(len)
    # Valid characters for IRC Blowfish-CBC IV: a-z A-Z 0-9 _
    letters = [('a'..'z'),('A'..'Z'),('0'..'9')].map { |i| i.to_a }.flatten << '_'
    (0...len).map { letters[SecureRandom.random_number(letters.length)] }.join
  end
end
