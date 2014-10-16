# -*- encoding: utf-8 -*-
VERSION = '0.1.0'

Gem::Specification.new do |spec|
  spec.name          = "motion-set"
  spec.version       = VERSION
  spec.authors       = ['Vladimir Keleshev']
  spec.email         = ['vladimir@keleshev.com']
  spec.description   = %q{Set implementation for RubyMotion}
  spec.summary       = %q{Set implementation for RubyMotion}
  spec.homepage      = ""
  spec.license       = ""

  files = []
  files << 'README.md'
  files.concat(Dir.glob('lib/**/*.rb'))
  spec.files         = files
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rake'
end
