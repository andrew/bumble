# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bumble/version"

Gem::Specification.new do |s|
  s.name        = "bumble"
  s.version     = Bumble::VERSION
  s.authors     = ["Andrew Nesbitt"]
  s.email       = ["andrewnez@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Rails 3 Tumblog Engine}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency(%q<rails>,         ["3.0.7"])
  s.add_dependency(%q<will_paginate>, ["~>3.0.pre2"])
  s.add_dependency(%q<gravtastic>,    ["~>2.1.3"])
  s.add_dependency(%q<authlogic>,     ["~>2.1.1"])
  s.add_dependency(%q<rdiscount>,     ["1.6.8"])
  s.add_dependency(%q<haml>,          ["~>3.1.1"])
  s.add_dependency(%q<texticle>,      ["~>1.0.4"])
  s.add_dependency(%q<paperclip>,     ["2.3.4"])
  s.add_dependency(%q<pg>,            ["~>0.10.1"])
  s.add_dependency(%q<aws-s3>,        ["~>0.6.2"])
  s.add_dependency(%q<dynamic_form>,  ["1.1.4"])
  s.add_dependency(%q<sass>,          ["~>3.1.2"])
  s.add_dependency(%q<akismetor>)
end
