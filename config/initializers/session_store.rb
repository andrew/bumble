# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_bumble_session',
  :secret      => 'aa72f881dccd3b64950e666d3584ca17e47006c6d7497261b39b4a0173946bdc2cf7a7cb8fc10e3a99bb9bbd9c6a325f2e0fd7597833ae82489067331adbf8d0'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
