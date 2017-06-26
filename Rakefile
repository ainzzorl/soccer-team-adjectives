require 'rake'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = Dir.glob('spec/**/*_spec.rb')
end

RuboCop::RakeTask.new(:rubocop) do |task|
  task.fail_on_error = true
end

task default: %i[spec rubocop]
