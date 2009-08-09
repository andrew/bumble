# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://#{DOMAIN}"

SitemapGenerator::Sitemap.add_links do |sitemap|
  sitemap.add posts_path, :priority => 0.7, :changefreq => 'daily'

  Post.published.all_public.find(:all).each do |p|
    sitemap.add post_path(p), :lastmod => p.updated_at
  end
end
