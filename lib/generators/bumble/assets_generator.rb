module Bumble
  class AssetsGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates/assets', __FILE__)

    def regenerate
      directory "images", "public/images"
      directory "javascripts", "public/javascripts"
    end
  end
end
