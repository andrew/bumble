class FullTextSearch < ActiveRecord::Migration
  def self.up
      ActiveRecord::Base.connection.execute(<<-'eosql')
        DROP index IF EXISTS posts_fts_idx
      eosql
      ActiveRecord::Base.connection.execute(<<-'eosql')
                CREATE index posts_fts_idx
        ON posts
        USING gin((to_tsvector('english', coalesce(posts.title, '') || ' ' || coalesce(posts.link_url, '') || ' ' || coalesce(posts.image_url, '') || ' ' || coalesce(posts.video_embed, '') || ' ' || coalesce(posts.description, '') || ' ' || coalesce(posts.quote, '') || ' ' || coalesce(posts.permalink, '') || ' ' || coalesce(posts.via, ''))))

      eosql
  end
end
