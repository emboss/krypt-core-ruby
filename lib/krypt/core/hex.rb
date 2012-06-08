module Krypt

class KryptError < StandardError
end

module Hex

  class HexError < KryptError
  end

  HEX_TABLE = [48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 97, 98, 99, 100, 101, 102]
  HEX_TABLE_INV = [
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, -1, -1, 
    -1, -1, -1, -1, -1, 10, 11, 12, 13, 14, 15, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 10, 11, 12, 
    13, 14, 15
  ] #102
  HEX_INV_MAX = 102

  private_constant :HEX_TABLE
  private_constant :HEX_TABLE_INV
  private_constant :HEX_INV_MAX

  def self.encode(data)
    ("\0" * (data.size * 2)).tap do |ret|
      data.each_byte.each_with_index do |b, i|
        ret.setbyte(i * 2, HEX_TABLE[b >> 4])
        ret.setbyte(i * 2 + 1, HEX_TABLE[b & 0x0f])
      end
    end
  end

  def self.decode(data)
    len = data.size
    raise HexError.new("Hex-encoded data length must be a multiple of 2") unless len % 2 == 0
    "".tap do |ret|
      (len / 2).times do |i|
        c = data[i * 2].ord
        d = data[i * 2 + 1].ord
        if c > HEX_INV_MAX || d > HEX_INV_MAX
          raise HexError.new("Illegal hex character detected: #{c}|#{d}")
        end
        b = HEX_TABLE_INV[c]
        raise illegal_hex_char(c) if b < 0
        b = b << 4
        bb = HEX_TABLE_INV[d]
        raise illegal_hex_char(d) if bb < 0
        ret << (b | bb)
      end
    end
  end

  private

  def self.illegal_hex_char(c)
    HexError.new("Illegal hex character detected: #{c}")
  end

end
end
