class Post < ActiveRecord::Base
  
  TYPES = %w(Blog Video Quote Image Link Code)
  
  has_many :comments
  belongs_to :user
  
  has_permalink :title
  
  validates_presence_of :user
  validates_inclusion_of :type, :in => TYPES
    
  def to_param
    title.blank? ? "#{id}" : "#{permalink}"
  end
  
  cattr_reader :per_page
  @@per_page = 10
  
  named_scope :all_public, :conditions => {:publicly_viewable => true}
  named_scope :all_private, :conditions => {:publicly_viewable => false}
  named_scope :published, lambda {{:conditions => ["published_at < :now", { :now => Time.now.utc }]}}

end
