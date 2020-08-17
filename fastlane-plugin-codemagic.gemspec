# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/codemagic/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-codemagic'
  spec.version       = Fastlane::Codemagic::VERSION
  spec.author        = 'Mikhail Matsera'
  spec.email         = 'mmatsera@gmail.com'

  spec.summary       = 'Fastlane plugin to trigger a Codemagic build with some options'
  spec.homepage      = "https://github.com/jetcore/fastlane-plugin-codemagic"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  # Don't add a dependency to fastlane or fastlane_re
  # since this would cause a circular dependency

  # spec.add_dependency 'your-dependency', '~> 1.0.0'

  spec.add_development_dependency('pry')
  spec.add_development_dependency('bundler')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('rspec_junit_formatter')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('rubocop', '0.49.1')
  spec.add_development_dependency('rubocop-require_tools')
  spec.add_development_dependency('simplecov')
  spec.add_development_dependency('fastlane', '>= 2.154.0')
end
