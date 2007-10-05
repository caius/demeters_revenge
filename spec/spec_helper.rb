begin
  require 'rubygems'
  require 'spec'
  
rescue LoadError
  puts "Please install rspec and mocha to run the tests."
  exit 1
end

Spec::Runner.configure do |config|
  config.mock_with :mocha
end