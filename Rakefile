require 'rake'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new :test do |task|
  task.pattern = Dir.glob('spec/**/*_spec.rb')
end

task default: :test
