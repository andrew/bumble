atom_feed(:schema_date => 2008, :root_url => root_url, :url => comments_url(:format => :atom)) do |feed|
  feed.title "Comments Feed"
  feed.updated @comments.first.updated_at

  for comment in @comments
    feed.entry(comment, :url => post_url(comment.post, :anchor => dom_id(comment))) do |entry|
      entry.title "Comment #{comment.id}"
      entry.author do |author|
        author.name comment.author
        author.uri comment.author_url
      end
      entry.content markdown(comment.body), :type => 'html'
    end
  end
end