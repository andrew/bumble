Gem::Specification.new do |s|
  s.name = 'permalink_fu'
  s.version = '0.1.6'
  s.summary = %{ActiveRecord plugin for automatically converting fields to permalinks.}
  s.description = %{}
  s.date = %q{2008-10-16}
  s.author = "Damian Janowski"
  s.email = "damian.janowski@gmail.com"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.files = ["lib/permalink_fu/rake/tasks.rb", "lib/permalink_fu/spec/matchers.rb", "lib/permalink_fu/spec.rb", "lib/permalink_fu.rb", "rails/tasks/permalink_fu.rake", "init.rb", "README.markdown", "MIT-LICENSE", "Rakefile"]

  s.require_paths = ['lib']

  s.extra_rdoc_files = ["README.textile"]
  s.has_rdoc = false
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "permalink_fu", "--main", "README.textile"]
end

