# frozen_string_literal: true

require 'rspec/core/rake_task'
require 'bump/tasks'

Bump.tag_by_default = true

RSpec::Core::RakeTask.new :test do |task|
  task.pattern = Dir.glob('spec/**/*_spec.rb')
end

desc 'Run the whole CI job suite as Travis would'
task :ci do
  sh('bundle exec wwtd')
end

desc 'Run the linter'
task :lint do
  sh('bundle exec rubocop')
end

task default: :test
