class Comment < ActiveRecord::Base
  include Gravtastic
  belongs_to :post # TODO , :counter_cache => true
  belongs_to :user

  validates_presence_of :post, :body
  validates_presence_of :author_name, :author_email, :if => :anonymous?
  validates_format_of :author_email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :allow_blank => :true

  is_gravtastic :with => :email, :rating => 'R', :size => 30

  after_save :set_parent_delta
  after_create :email_post_author

  scope :ham, :conditions => {:approved => true}
  scope :spam, :conditions => {:approved => false}
  scope :old, lambda {{:conditions => ["created_at < :now", { :now => 14.days.ago }]}}

  def set_parent_delta
    self.post.update_attributes(:delta => true)
  end

  def email_post_author
    Notifier.deliver_new_comment_alert(self) if (user_id != post.user_id) && approved
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

  before_create :check_for_spam

  def request=(request)
    self.user_ip    = request.remote_ip
    self.user_agent = request.env['HTTP_USER_AGENT']
    self.referrer   = request.env['HTTP_REFERER']
  end

  def check_for_spam
    self.approved = !Akismetor.spam?(akismet_attributes)
    true # return true so it doesn't stop save
  end

  def akismet_attributes
    {
      :key                  => '4a8bfe691b69',
      :blog                 => "http://#{DOMAIN}",
      :user_ip              => user_ip,
      :user_agent           => user_agent,
      :comment_author       => author,
      :comment_author_email => email,
      :comment_author_url   => author_url,
      :comment_content      => body
    }
  end

  def mark_as_spam!
    update_attribute(:approved, false)
    Akismetor.submit_spam(akismet_attributes)
  end

  def mark_as_ham!
    update_attribute(:approved, true)
    Akismetor.submit_ham(akismet_attributes)
  end
end