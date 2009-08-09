atom_feed(:schema_date => 2009, :root_url => root_url, :url => posts_url(:format => :atom)) do |feed|
  feed.title "Posts Feed"
  feed.updated @posts.first.updated_at

  for post in @posts
    feed.entry(post, :url => post_url(post)) do |entry|
      entry.title post.title
      entry.author do |author|
        author.name post.user.name
        author.url post.user.url
      end
      entry.content render_post(post), :type => 'html'
    end
  end
end