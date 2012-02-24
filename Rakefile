require 'rake'
require 'rspec/core/rake_task'
require 'rdoc/task'

KRYPT_HOME = '../krypt'

task :default => :spec

RSpec::Core::RakeTask.new('spec-run') do |spec|
  spec.pattern = File.join(KRYPT_HOME, 'spec/**/*_spec.rb')
  spec.fail_on_error = false
end

Rake::RDocTask.new("doc") do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title = "Krypt-Core API"
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*')
end
