# -*- encoding: utf-8 -*-
require File.expand_path('../lib/media_magick/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Lucas Renan',            'Rodrigo Brancher',    'Rodrigo Pestana']
  gem.email         = ['contato@lucasrenan.com', 'rbrancher@gmail.com', 'rodrigo.pest@gmail.com']
  gem.description   = %q{MediaMagick aims to make dealing with multimedia resources a very easy task – like magic.}
  gem.summary       = %q{MediaMagick aims to make dealing with multimedia resources a very easy task – like magic. It wraps up robust solutions for upload, associate and display images, videos, audios and files to any model in your rails app.}
  gem.homepage      = 'https://github.com/nudesign/media_magick'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'media_magick'
  gem.require_paths = ['lib']
  gem.version       = MediaMagick::VERSION
  gem.license       = 'MIT'

  gem.add_dependency 'carrierwave'
  # gem.add_dependency 'mongoid',        '>= 2.7.0'
  gem.add_dependency 'plupload-rails', '~> 1.1.0'
  gem.add_dependency 'rails',          '~> 4.2.5'
  gem.add_dependency 'mini_magick',    '~> 3.6.0'

  gem.add_development_dependency 'rake',         '~> 10.1.0'
  gem.add_development_dependency 'rspec-rails',  '~> 2.14.0'
  gem.add_development_dependency 'simplecov',    '~> 0.7.0'
  gem.add_development_dependency 'guard-rspec',  '~> 4.0.0'
  gem.add_development_dependency 'rb-fsevent',   '~> 0.9.0'
end
