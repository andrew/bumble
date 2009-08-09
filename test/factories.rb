Factory.define :user do |f|
  f.sequence(:email) {|n| "person#{n}@something.co.uk" }
  f.password 'password'
  f.first_name 'Andrew'
  f.password_confirmation { |u| u.password }
end

Factory.define :post do |f|
  f.title 'Hello world!'
  f.description 'content'
  f.association(:user)
  f.published_at 1.week.ago
  f.publicly_viewable true
end

Factory.define :blog do |f|
  f.title 'Hello world!'
  f.description 'content'
  f.association(:user)
  f.published_at 1.week.ago
  f.publicly_viewable true
end

Factory.define :comment do |f|
  f.body 'I love this!'
  f.association(:user)
  f.post {|post| post.association(:blog) }
end
