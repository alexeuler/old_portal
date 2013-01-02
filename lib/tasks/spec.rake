require 'rspec/core/rake_task'

task("spec").clear
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = "--format documentation"
  t.rspec_opts << " --debug"
end