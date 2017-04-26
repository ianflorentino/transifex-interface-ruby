# coding: utf-8
require 'transifex/version'

Gem::Specification.new do |spec|
  spec.name          = "tx-ruby"
  spec.version       = Transifex::VERSION
  spec.authors       = ["Ian Florentino, Fred-grais"]
  spec.email         = ["ianflorentino88@gmail.com"]
  spec.description   = %q{A Transifex API interface written in Ruby}
  spec.summary       = %q{This gem allows you to communicate with the Transifex API to perform every possible actions listed in the documentation: http://docs.transifex.com/developer/api/}
  spec.homepage      = "https://github.com/ianflorentino/tx-ruby"
  spec.license       = "MIT"

  spec.files         = Dir['{lib,spec}/**/*']
  spec.require_path  = "lib"
  spec.platform      = Gem::Platform::RUBY
end
