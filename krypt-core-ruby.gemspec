Gem::Specification.new do |s|
  s.name = 'krypt-core-ruby'
  s.version = '0.0.1'
  s.author = 'Hiroshi Nakamura, Martin Bosslet'
  s.email = 'Martin.Bosslet@gmail.com'
  s.homepage = 'https://github.com/krypt/krypt-core-ruby'
  s.summary = 'Ruby implementation of the krypt-core API'
  s.files = %w(LICENSE) + Dir.glob('{bin,lib,spec,test}/**/*')
  s.test_files = Dir.glob('test/**/test_*.rb')
  s.require_path = 'lib'
  s.license = 'MIT'
end
