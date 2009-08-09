# reindex the database
every 1.day, :at => '3:30 am' do
  rake "thinking_sphinx:index"
end

# recreate the sitemap
every 1.day, :at => '4:30 am' do
  rake "sitemap:refresh"
end