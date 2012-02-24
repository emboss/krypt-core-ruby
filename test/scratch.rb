require 'krypt-core'
require 'pp'

md = Krypt::Digest.new("SHA1")
md.update("test")
digest = md.digest

pp digest

puts md.name
puts md.digest_length
puts md.block_length

pp Krypt::Digest::SHA1.new.digest("test")

