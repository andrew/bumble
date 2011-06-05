require 'bumble/version'
require 'pathname'
require 'rails'
require 'haml'
require 'authlogic'
require 'texticle'
require 'will_paginate'
require 'gravtastic'
require 'dynamic_form'
require 'paperclip'
require 'rdiscount'
require 'akismetor'

module Bumble
  class Engine < Rails::Engine
    config.autoload_paths << File.expand_path("../../app/models/posts", __FILE__)
  end
end
