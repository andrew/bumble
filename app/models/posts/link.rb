class Link < Post
  validates_presence_of :link_url

  def title
    self.read_attribute(:title).blank? ? self.link_url : self.read_attribute(:title)
  end
end
