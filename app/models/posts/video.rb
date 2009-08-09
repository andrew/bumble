class Video < Post
  validates_presence_of :video_embed, :if => Proc.new { |video| video.link_url.blank? }
  validates_presence_of :link_url, :if => Proc.new { |video| video.video_embed.blank? }
end
