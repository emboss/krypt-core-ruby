source :rubygems

gem 'ffi'
gem 'krypt-provider-openssl', :path => File.expand_path('../krypt-provider-openssl', File.dirname(__FILE__))

group :development do
  gem 'rake'
end

group :test do
  gem 'rspec'
gem 'jruby-openssl', :platforms => :jruby
end

gemspec
