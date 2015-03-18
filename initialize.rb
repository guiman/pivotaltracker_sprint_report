require 'bundler'
Bundler.load

extension_lib = File.join(__dir__, 'lib')
$:.unshift(extension_lib) unless $:.include?(extension_lib)

require 'pivotal_extension'
