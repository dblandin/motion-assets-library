# -*- encoding: utf-8 -*-
Gem::Specification.new do |spec|
  spec.name          = 'motion-assets-library'
  spec.version       = '1.3.0'
  spec.authors       = ['Devon Blandin']
  spec.email         = ['dblandin@gmail.com']
  spec.description   = %q{Easy access to iOS media assets via ALAssetsLibrary}
  spec.summary       = %q{Easy access to iOS media assets via ALAssetsLibrary}
  spec.homepage      = 'https://github.com/dblandin/motion-assets-library'
  spec.license       = 'MIT'

  files = []
  files << 'README.md'
  files.concat(Dir.glob('lib/**/*.rb'))
  spec.files         = files
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rake'
end
