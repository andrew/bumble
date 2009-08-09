namespace :permalinks do
  desc 'Re-builds permalinks for all models.'
  task :rebuild => :environment do
    models = if ENV['MODEL']
               Array(ENV['MODEL'].constantize)
             else
               Dir[RAILS_ROOT + "/app/models/**/*.rb"].each { |f| require f }
               ActiveRecord::Base.send(:subclasses)
             end

    models.each do |model|
      next unless model.respond_to?(:permalink_field)

      if model.permalink_options.include?(:param)
        puts "Skipping #{model} because it doesn't include the ID in #to_param."
        next
      end

      field = model.permalink_field

      objects = nil

      while objects.nil? || !objects.empty?
        objects = model.find(:all, :conditions => {:permalink => nil}, :limit => 20)

        objects.each do |o|
          puts "#{model} #{o.id}"
          o.send(:create_unique_permalink)
          value = o.send(model.permalink_field)
          puts "=> #{value.inspect}"
          model.update_all("#{field} = '#{value}'", "id = #{o.id}")
        end
      end
    end
  end
end
