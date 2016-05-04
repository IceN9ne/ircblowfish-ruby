require 'spec_helper'

describe IrcBlowfish do
  # Thank you deafult test from builder :)
  it 'has a version number' do
    expect(IrcBlowfish::VERSION).not_to be nil
  end

  describe '::encrypt_ecb' do
    it 'returns the encrypted string of a message' do
      # Using ecb: prefix
      expect(IrcBlowfish.encrypt_ecb('This is a plaintext string', 'ecb:AWeakKey')).to eq '+OK OkFFk1k//fB1j1Gup0ZMkiK/FHxQd12Ka/G1U5enV1cMjBs.'
      expect(IrcBlowfish.encrypt_ecb('An alternative plaintext string', 'ecb:ABetter?Key')).to eq '+OK vKB5G.YXf8b/FSMQo0tlrcq0JY0.O/xT4Ks/JDCLX/CKbTr1'

      # Using old: prefix
      expect(IrcBlowfish.encrypt_ecb('This is a plaintext string', 'old:AWeakKey')).to eq '+OK OkFFk1k//fB1j1Gup0ZMkiK/FHxQd12Ka/G1U5enV1cMjBs.'
      expect(IrcBlowfish.encrypt_ecb('An alternative plaintext string', 'old:ABetter?Key')).to eq '+OK vKB5G.YXf8b/FSMQo0tlrcq0JY0.O/xT4Ks/JDCLX/CKbTr1'

      # Using no prefix
      expect(IrcBlowfish.encrypt_ecb('This is a plaintext string', 'AWeakKey')).to eq '+OK OkFFk1k//fB1j1Gup0ZMkiK/FHxQd12Ka/G1U5enV1cMjBs.'
      expect(IrcBlowfish.encrypt_ecb('An alternative plaintext string', 'ABetter?Key')).to eq '+OK vKB5G.YXf8b/FSMQo0tlrcq0JY0.O/xT4Ks/JDCLX/CKbTr1'

      # Use a short key
      expect(IrcBlowfish.encrypt_ecb('This is a plaintext string', 'ecb:a')).to eq '+OK xyxLi.N8aNx16YME11FHbIN1TJAND/oIDBB/NUTxY.nZohB.'

      # Use a short message
      expect(IrcBlowfish.encrypt_ecb('a', 'ecb:AWeakKey')).to eq '+OK zMxh41rjV1j/'
    end

    it 'handles a nil or empty key' do
      expect(IrcBlowfish.encrypt_ecb('This is a plaintext string', nil)).to eq 'This is a plaintext string'
      expect(IrcBlowfish.encrypt_ecb('This is a plaintext string', '')).to eq 'This is a plaintext string'
    end

    it 'handles a nil or empty message' do
      expect(IrcBlowfish.encrypt_ecb(nil, 'ecb:AWeakKey')).to eq nil
      expect(IrcBlowfish.encrypt_ecb('', 'ecb:AWeakKey')).to eq ''
    end

    it 'handles a prefix only key (ecb: or old:)' do
      expect(IrcBlowfish.encrypt_ecb('This is a plaintext string', 'ecb:')).to eq 'This is a plaintext string'
      expect(IrcBlowfish.encrypt_ecb('This is a plaintext string', 'old:')).to eq 'This is a plaintext string'
    end
  end

  describe '::decrypt_ecb' do
    it 'returns the decrypted string of a message' do
      # Using ecb: prefix
      expect(IrcBlowfish.decrypt_ecb('+OK OkFFk1k//fB1j1Gup0ZMkiK/FHxQd12Ka/G1U5enV1cMjBs.', 'ecb:AWeakKey')).to eq 'This is a plaintext string'
      expect(IrcBlowfish.decrypt_ecb('+OK vKB5G.YXf8b/FSMQo0tlrcq0JY0.O/xT4Ks/JDCLX/CKbTr1', 'ecb:ABetter?Key')).to eq 'An alternative plaintext string'

      # Using old: prefix
      expect(IrcBlowfish.decrypt_ecb('+OK OkFFk1k//fB1j1Gup0ZMkiK/FHxQd12Ka/G1U5enV1cMjBs.', 'old:AWeakKey')).to eq 'This is a plaintext string'
      expect(IrcBlowfish.decrypt_ecb('+OK vKB5G.YXf8b/FSMQo0tlrcq0JY0.O/xT4Ks/JDCLX/CKbTr1', 'old:ABetter?Key')).to eq 'An alternative plaintext string'

      # Using no prefix
      expect(IrcBlowfish.decrypt_ecb('+OK OkFFk1k//fB1j1Gup0ZMkiK/FHxQd12Ka/G1U5enV1cMjBs.', 'AWeakKey')).to eq 'This is a plaintext string'
      expect(IrcBlowfish.decrypt_ecb('+OK vKB5G.YXf8b/FSMQo0tlrcq0JY0.O/xT4Ks/JDCLX/CKbTr1', 'ABetter?Key')).to eq 'An alternative plaintext string'
      expect(IrcBlowfish.decrypt_ecb('+mcps OkFFk1k//fB1j1Gup0ZMkiK/FHxQd12Ka/G1U5enV1cMjBs.', 'AWeakKey')).to eq 'This is a plaintext string'
      expect(IrcBlowfish.decrypt_ecb('+mcps vKB5G.YXf8b/FSMQo0tlrcq0JY0.O/xT4Ks/JDCLX/CKbTr1', 'ABetter?Key')).to eq 'An alternative plaintext string'

      # Use a short key
      expect(IrcBlowfish.decrypt_ecb('+OK xyxLi.N8aNx16YME11FHbIN1TJAND/oIDBB/NUTxY.nZohB.', 'ecb:a')).to eq 'This is a plaintext string'

      # Use a short message
      expect(IrcBlowfish.decrypt_ecb('+OK zMxh41rjV1j/', 'ecb:AWeakKey')).to eq 'a'

      # Test for "+OK " message
      expect(IrcBlowfish.decrypt_ecb('+OK ', 'ecb:AWeakKey')).to eq ''
    end

    it 'handles a nil or empty key' do
      expect(IrcBlowfish.decrypt_ecb('+OK zMxh41rjV1j/', nil)).to eq '+OK zMxh41rjV1j/'
      expect(IrcBlowfish.decrypt_ecb('+OK zMxh41rjV1j/', '')).to eq '+OK zMxh41rjV1j/'
    end

    it 'handles a nil or empty message' do
      expect(IrcBlowfish.decrypt_ecb(nil, 'ecb:AWeakKey')).to eq nil
      expect(IrcBlowfish.decrypt_ecb('', 'ecb:AWeakKey')).to eq ''
    end

    it 'handles a prefix only key (ecb: or old:)' do
      expect(IrcBlowfish.decrypt_ecb('+OK zMxh41rjV1j/', 'ecb:')).to eq '+OK zMxh41rjV1j/'
      expect(IrcBlowfish.decrypt_ecb('+OK zMxh41rjV1j/', 'old:')).to eq '+OK zMxh41rjV1j/'
    end
  end

  describe '::encrypt_cbc' do
    # Due to the nature of the IV in Blowfish-CBC, we can't test for encryption output using the traditional method
    it 'returns the encrypted string of a message' do
      # Using cbc: prefix
      expect(IrcBlowfish.decrypt_cbc(IrcBlowfish.encrypt_cbc('This is a plaintext string', 'cbc:AWeakKey'), 'cbc:AWeakKey')).to eq 'This is a plaintext string'
      expect(IrcBlowfish.decrypt_cbc(IrcBlowfish.encrypt_cbc('An alternative plaintext string', 'cbc:ABetter?Key'), 'cbc:ABetter?Key')).to eq 'An alternative plaintext string'

      # Using default prefix
      expect(IrcBlowfish.decrypt_cbc(IrcBlowfish.encrypt_cbc('This is a plaintext string', 'AWeakKey'), 'AWeakKey')).to eq 'This is a plaintext string'
      expect(IrcBlowfish.decrypt_cbc(IrcBlowfish.encrypt_cbc('An alternative plaintext string', 'ABetter?Key'), 'ABetter?Key')).to eq 'An alternative plaintext string'

      # Use a short key
      expect(IrcBlowfish.decrypt_cbc(IrcBlowfish.encrypt_cbc('This is a plaintext string', 'a'), 'a')).to eq 'This is a plaintext string'

      # Use a short message
      expect(IrcBlowfish.decrypt_cbc(IrcBlowfish.encrypt_cbc('a', 'AWeakKey'), 'AWeakKey')).to eq 'a'
    end

    it 'handles a nil or empty key' do
      expect(IrcBlowfish.encrypt_cbc('This is a plaintext string', nil)).to eq 'This is a plaintext string'
      expect(IrcBlowfish.encrypt_cbc('This is a plaintext string', '')).to eq 'This is a plaintext string'
    end

    it 'handles a nil or empty message' do
      expect(IrcBlowfish.encrypt_cbc(nil, 'AWeakKey')).to eq nil
      expect(IrcBlowfish.encrypt_cbc('', 'AWeakKey')).to eq ''
    end

    it 'handles a prefix only key (cbc:)' do
    end
  end

  describe '::decrypt_cbc' do
    it 'returns the decrypted string of a message' do
      # Using cbc: prefix
      expect(IrcBlowfish.decrypt_cbc('+OK *5q3IoVBiowViKBNazrpnBgfBNbbgyZVU6vJnfMkRsKCsDqkscUY9XA==', 'cbc:AWeakKey')).to eq 'This is a plaintext string'
      expect(IrcBlowfish.decrypt_cbc('+OK *r6jziPn/YqkY62L+/7tjqIGLeh22K3V8', 'cbc:AWeakKey')).to eq "\xE3\x81\x93\xE3\x82\x93\xE3\x81\xAB\xE3\x81\xA1\xE3\x82\x8F".force_encoding('BINARY')

      # Using no prefix
      expect(IrcBlowfish.decrypt_cbc('+OK *5q3IoVBiowViKBNazrpnBgfBNbbgyZVU6vJnfMkRsKCsDqkscUY9XA==', 'AWeakKey')).to eq 'This is a plaintext string'
      expect(IrcBlowfish.decrypt_cbc('+OK *r6jziPn/YqkY62L+/7tjqIGLeh22K3V8', 'AWeakKey')).to eq "\xE3\x81\x93\xE3\x82\x93\xE3\x81\xAB\xE3\x81\xA1\xE3\x82\x8F".force_encoding('BINARY')
      expect(IrcBlowfish.decrypt_cbc('+mcps *5q3IoVBiowViKBNazrpnBgfBNbbgyZVU6vJnfMkRsKCsDqkscUY9XA==', 'AWeakKey')).to eq 'This is a plaintext string'

      # Use a short key
      expect(IrcBlowfish.decrypt_cbc('+OK *i55NjKDV9JqmnXH0h8RIQJ/ZqwbU3GYHrNazdIcgbxK1GD1Dr1jtxw==', 'a')).to eq 'This is a plaintext string'

      # Use a short message
      expect(IrcBlowfish.decrypt_cbc('+OK *w85i4OXHMQEL/Louy3/HwQ==', 'AWeakKey')).to eq 'a'

      # Test for empty crypted string
      expect(IrcBlowfish.decrypt_cbc('+OK *xIkCHSsmCN8=', 'AWeakKey')).to eq ''
    end

    it 'handles a nil or empty key' do
      expect(IrcBlowfish.decrypt_cbc('+OK *5q3IoVBiowViKBNazrpnBgfBNbbgyZVU6vJnfMkRsKCsDqkscUY9XA==', nil)).to eq '+OK *5q3IoVBiowViKBNazrpnBgfBNbbgyZVU6vJnfMkRsKCsDqkscUY9XA=='
      expect(IrcBlowfish.decrypt_cbc('+OK *5q3IoVBiowViKBNazrpnBgfBNbbgyZVU6vJnfMkRsKCsDqkscUY9XA==', '')).to eq '+OK *5q3IoVBiowViKBNazrpnBgfBNbbgyZVU6vJnfMkRsKCsDqkscUY9XA=='
    end

    it 'handles a nil or empty message' do
      expect(IrcBlowfish.decrypt_cbc(nil, 'cbc:AWeakKey')).to eq nil
      expect(IrcBlowfish.decrypt_cbc('', 'cbc:AWeakKey')).to eq ''
    end

    it 'handles a prefix only key (cbc:)' do
      expect(IrcBlowfish.decrypt_cbc('+OK *5q3IoVBiowViKBNazrpnBgfBNbbgyZVU6vJnfMkRsKCsDqkscUY9XA==', 'cbc:')).to eq '+OK *5q3IoVBiowViKBNazrpnBgfBNbbgyZVU6vJnfMkRsKCsDqkscUY9XA=='
    end
  end

  describe '::encrypt' do
    it 'returns the encrypted string of a message' do
      # Test the 4 supported key types
      expect(IrcBlowfish.encrypt('This is a plaintext string', 'ecb:AWeakKey')).to eq '+OK OkFFk1k//fB1j1Gup0ZMkiK/FHxQd12Ka/G1U5enV1cMjBs.'
      expect(IrcBlowfish.encrypt('This is a plaintext string', 'old:AWeakKey')).to eq '+OK OkFFk1k//fB1j1Gup0ZMkiK/FHxQd12Ka/G1U5enV1cMjBs.'
      expect(IrcBlowfish.decrypt(IrcBlowfish.encrypt('This is a plaintext string', 'cbc:AWeakKey'), 'cbc:AWeakKey')).to eq 'This is a plaintext string'
      expect(IrcBlowfish.decrypt(IrcBlowfish.encrypt('This is a plaintext string', 'AWeakKey'), 'AWeakKey')).to eq 'This is a plaintext string'
    end

    it 'handles a nil or empty key' do
      expect(IrcBlowfish.encrypt('This is a plaintext string', nil)).to eq 'This is a plaintext string'
      expect(IrcBlowfish.encrypt('This is a plaintext string', '')).to eq 'This is a plaintext string'
    end

    it 'handles a nil or empty message' do
      expect(IrcBlowfish.encrypt(nil, 'ecb:AWeakKey')).to eq nil
      expect(IrcBlowfish.encrypt('', 'ecb:AWeakKey')).to eq ''
    end
  end

  describe '::decrypt' do
    it 'returns the decrypted string of a message' do
      # Test the 4 supported key types
      expect(IrcBlowfish.decrypt('+OK OkFFk1k//fB1j1Gup0ZMkiK/FHxQd12Ka/G1U5enV1cMjBs.', 'ecb:AWeakKey')).to eq 'This is a plaintext string'
      expect(IrcBlowfish.decrypt('+OK OkFFk1k//fB1j1Gup0ZMkiK/FHxQd12Ka/G1U5enV1cMjBs.', 'old:AWeakKey')).to eq 'This is a plaintext string'
      expect(IrcBlowfish.decrypt('+OK *5q3IoVBiowViKBNazrpnBgfBNbbgyZVU6vJnfMkRsKCsDqkscUY9XA==', 'cbc:AWeakKey')).to eq 'This is a plaintext string'
      expect(IrcBlowfish.decrypt('+OK *5q3IoVBiowViKBNazrpnBgfBNbbgyZVU6vJnfMkRsKCsDqkscUY9XA==', 'AWeakKey')).to eq 'This is a plaintext string'
    end

    it 'handles a nil or empty key' do
      expect(IrcBlowfish.decrypt('This is a plaintext string', nil)).to eq 'This is a plaintext string'
      expect(IrcBlowfish.decrypt('This is a plaintext string', '')).to eq 'This is a plaintext string'
    end

    it 'handles a nil or empty message' do
      expect(IrcBlowfish.decrypt(nil, 'ecb:AWeakKey')).to eq nil
      expect(IrcBlowfish.decrypt('', 'ecb:AWeakKey')).to eq ''
    end
  end
end

describe IrcBlowfish::Base64 do
  describe '::encode' do
    it 'returns the encoded string of a message' do
      expect(IrcBlowfish::Base64.encode('asdfasdf')).to eq 'AfQqv/AfQqv/'
      expect(IrcBlowfish::Base64.encode("asdf\x00\x00\x00\x00")).to eq '......AfQqv/'
    end
  end

  describe '::decode' do
    it 'returns the decoded string of a message' do
      expect(IrcBlowfish::Base64.decode('AfQqv/AfQqv/')).to eq 'asdfasdf'
      expect(IrcBlowfish::Base64.decode('......AfQqv/')).to eq "asdf\x00\x00\x00\x00"
    end
  end
end
