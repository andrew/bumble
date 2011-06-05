# Configure the options for you site here
DOMAIN = 'example.com'
CONTACT_EMAIL = 'you@example.com'

Rails.application.config.action_mailer.default_url_options = { :host => DOMAIN }

SASS_PATH = File.join(File.dirname(__FILE__), *%w[.. .. public stylesheets sass])
CSS_PATH = File.expand_path(File.join(Rails.root, %w[public stylesheets]))
::Sass::Plugin.add_template_location(SASS_PATH, CSS_PATH)