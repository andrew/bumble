class Link < Post
  validates_presence_of :link_url, :title
end
