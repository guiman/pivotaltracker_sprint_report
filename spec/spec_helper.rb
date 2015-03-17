require 'bundler'
Bundler.require :default, :test

extension_lib = File.join(__dir__, '../lib')
$:.unshift(extension_lib) unless $:.include?(extension_lib)

require 'pivotal_extension'
require 'support/operations'

RSpec.configure do |conf|
  conf.after(:each) do
    Pivotal::Configuration::Repository.clear!
  end

  VCR.configure do |config|
    config.cassette_library_dir = File.join(__dir__,"support", "vcr_cassettes")
    config.hook_into :webmock
  end
end
