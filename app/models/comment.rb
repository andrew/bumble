class Comment < ActiveRecord::Base

  is_paranoid

  belongs_to :post
  belongs_to :user

  validates_presence_of :post, :body
  validates_presence_of :author_name, :author_email, :if => :anonymous?
  validates_format_of :author_email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :allow_blank => :true

  is_gravtastic :with => :email, :rating => 'R', :size => 30

  after_save :set_parent_delta
  after_create :email_post_author

  def set_parent_delta
    self.post.update_attributes(:delta => true)
  end

  def email_post_author
    Notifier.deliver_new_comment_alert(self) unless user_id == post.user_id
  end

  def anonymous?
    !user_id?
  end

  def email
    user_id.blank? ? author_email : user.email
  end

  def author
    user_id.blank? ? author_name : user.to_s
  end

  def author_url
    anonymous? ? read_attribute(:author_url) : user.url
  end
end