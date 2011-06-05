class AddMissingIndexes < ActiveRecord::Migration
  def self.up

    # These indexes were found by searching for AR::Base finds on your application
    # It is strongly recommanded that you will consult a professional DBA about your infrastucture and implemntation before
    # changing your database in that matter.
    # There is a possibility that some of the indexes offered below is not required and can be removed and not added, if you require
    # further assistance with your rails application, database infrastructure or any other problem, visit:
    #
    # http://www.railsmentors.org
    # http://www.railstutor.org
    # http://guides.rubyonrails.org

    add_index :posts, :permalink
    add_index :comments, :post_id
    add_index :posts, [:id, :type]
  end

  def self.down
    # remove_index :posts, :permalink
    remove_index :comments, :post_id
    remove_index :posts, :column => [:id, :type]
  end
end
