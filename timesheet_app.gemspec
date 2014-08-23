# -*- encoding: utf-8 -*-
require File.expand_path('../lib/timesheet_app/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["hunter"]
  gem.email         = ["hunter.wxhu@gmail.com"]
  gem.description   = %q{a time management system }
  gem.summary       = %q{a time management system}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "timesheet_app"
  gem.require_paths = ["lib", "app"]
  gem.version       = TimesheetApp::VERSION

  gem.add_dependency "padrino-core"
  gem.add_dependency  "rdiscount"
end
