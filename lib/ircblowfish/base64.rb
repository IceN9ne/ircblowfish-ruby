module IrcBlowfish
  module Base64
    B64 = './0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.freeze

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
