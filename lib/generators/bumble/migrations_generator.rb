module Bumble
  class MigrationsGenerator < Rails::Generators::Base

    source_root File.expand_path('../templates', __FILE__)

    include Rails::Generators::Migration

    def generate_migrations
      generate_migration('create_users')
      generate_migration('create_posts')
      generate_migration('create_comments')
      generate_migration('add_url_to_users')
      generate_migration('add_delta_to_posts')
      generate_migration('add_approved_to_comments')
      generate_migration('add_missing_indexes')
      generate_migration('create_assets')
      generate_migration('full_text_search')
    end

    private

    def generate_migration(name)
      begin
        migration_template "migrations/#{name}.rb", "db/migrate/#{name}.rb"
        sleep 1 # to make sure all migrations have a different number
      rescue
        puts "Skiping migration: #{name}"
      end
    end

    # Implement the required interface for Rails::Generators::Migration.
    def self.next_migration_number(dirname) #:nodoc:
      if ActiveRecord::Base.timestamped_migrations
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      else
        "%.3d" % (current_migration_number(dirname) + 1)
      end
    end
  end
end