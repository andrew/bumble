class Post < ActiveRecord::Base
  has_many :assets, :dependent => :destroy
  has_many :comments, :dependent => :destroy, :order => :created_at
  belongs_to :user

  accepts_nested_attributes_for :assets

  # has_permalink :title, :unless => Proc.new { |post| post.read_attribute(:title).blank? }

  validates_presence_of :user, :published_at

  before_validation :format_published_at

  def asset
    assets.first
  end

  def to_param
    permalink.blank? ? id.to_s : permalink
  end

  def self.types
    Dir[File.expand_path('../posts',__FILE__)+'/*.rb'].each { |f| require_dependency f }
    self.subclasses.collect(&:to_s).sort
  end

  def self.find_by_permalink_or_id(param)
    Post.find_by_permalink(param) || Post.find(param)
  end

  cattr_reader :per_page
  @@per_page = 5

  scope :all_public, :conditions => {:publicly_viewable => true}
  scope :all_private, :conditions => {:publicly_viewable => false}
  scope :published, lambda {{:conditions => ["published_at < :now", { :now => Time.now.utc }]}}

  def title
    read_attribute(:title).blank? ? "Post #{id}" : read_attribute(:title)
  end

  index do
    title
    link_url
    image_url
    video_embed
    description
    quote
    permalink
    type
    via
  end

  def format_published_at
    self.published_at = Time.now if self.published_at.nil?
  end
end