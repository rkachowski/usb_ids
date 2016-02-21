# -*- encoding: utf-8 -*-

require File.dirname(__FILE__) + "/lib/usb_ids/version"

Gem::Specification.new do |gem|
  gem.name          = "usb_ids"
  gem.version       = UsbIds::VERSION
  gem.summary       = "Maintain and query a database of USB ids"
  gem.description   = "Creates and updates an sqlite db of usb ids - can be used to generate a db for use in other programs,
or to directly query with usb vendor / product ids"
  gem.authors       = ["Donald Hutchison"]
  gem.email         = ["git@toastymofo.net"]
  gem.homepage      = "https://github.com/rkachowski/usb_ids"
  gem.license       = "MIT"

  gem.files         = Dir["{**/}{.*,*}"].select{ |path| File.file?(path) && path !~ /^pkg/ }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

   gem.required_ruby_version = "~> 2.0"

  gem.add_runtime_dependency 'sqlite3', '~> 1.3'
end
