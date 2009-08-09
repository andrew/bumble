class Post < ActiveRecord::Base
  is_paranoid

  has_many :comments, :dependent => :destroy
  belongs_to :user

  has_permalink :title, :unless => Proc.new { |post| post.read_attribute(:title).blank? }

  validates_presence_of :user, :published_at

  def to_param
    permalink.blank? ? id.to_s : permalink
  end

  def self.types
    Dir["#{RAILS_ROOT}/app/models/posts/*.rb"].each { |f| require_dependency f }
    self.subclasses.collect(&:to_s).sort
  end

  def self.find_by_permalink_or_id(param)
    Post.find_by_permalink(param) || Post.find(param)
  end

  cattr_reader :per_page
  @@per_page = 5

  named_scope :all_public, :conditions => {:publicly_viewable => true}
  named_scope :all_private, :conditions => {:publicly_viewable => false}
  named_scope :published, lambda {{:conditions => ["published_at < :now", { :now => Time.now.utc }]}}

  def title
    read_attribute(:title).blank? ? "Post #{id}" : read_attribute(:title)
  end

  define_index do
    # fields
    indexes :title
    indexes :link_url
    indexes :image_url
    indexes :video_embed
    indexes :description
    indexes :quote
    indexes :permalink
    indexes :type
    indexes :via

    indexes comments.body, :as => :comments_body

    # attributes
    has :created_at, :updated_at, :published_at, :user_id

    where 'posts.deleted_at IS NULL AND posts.publicly_viewable = 1'

    set_property :delta => true
  end
end