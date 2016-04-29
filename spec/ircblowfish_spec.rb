require 'spec_helper'

describe IrcBlowfish do
  it 'has a version number' do
    expect(IrcBlowfish::VERSION).not_to be nil
  end

  describe '::encrypt_ecb' do
    it 'returns the encrypted string of a message (ecb:)' do
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
  end
end
