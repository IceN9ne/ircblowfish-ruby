module IrcBlowfish
  module Base64
    # The Base64 characters modified for IRC Blowfish-ECB
    B64 = './0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.freeze

    # Encodes a binary string in modified IRC Blowfish-ECB Base64
    # @param bin [String] binary encoded string to be encoded
    # @return [String] the Base64 encoded string
    def self.encode(bin)
      str = ''

      k = -1
      while k < bin.length - 1
        (l,r) = [0,0].map do |i|
          [24, 16, 8, 0].each do |j|
            i += bin[k+=1].ord << j
          end
          i
        end
        [r,l].each do |i|
          6.times do
            str += B64[i & 0x3F]
            i >>= 6
          end
        end
      end

      str
    end

    # Decodes an IRC Blowfish-ECB Base64 string
    # @param str [String] the Base64 encoded string
    # @return the decoded string
    def self.decode(str)
      bin = ''

      k = -1
      while k < str.length - 1
        (l,r) = [0,0].map do |i|
          6.times do |j|
            i |= B64.index(str[k+=1]) << (j * 6)
          end
          i
        end
        [r,l].each do |i|
          [24, 16, 8, 0].each do |j|
            bin += ((i & (0xFF << j)) >> j).chr
          end
        end
      end

      bin
    end
  end
end
