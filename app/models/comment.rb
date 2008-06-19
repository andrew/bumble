class Comment < ActiveRecord::Base

  belongs_to :post # TODO , :counter_cache => true
  belongs_to :user
  
  validates_presence_of :post, :body
  validates_presence_of :author_name, :author_email, :if => :anonymous?
  validates_format_of :author_email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :allow_blank => :true

  def anonymous?
    !user_id?
  end
  
  def display_email
    user_id.blank? ? author_email : user.email
  end
  
  def display_name
    user_id.blank? ? author_name : user.login
  end
  
end