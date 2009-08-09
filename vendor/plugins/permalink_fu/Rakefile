require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'spec/rake/spectask'

gem_spec_file = 'permalink_fu.gemspec'

gem_spec = eval(File.read(gem_spec_file)) rescue nil

desc 'Default: run all specs.'
task :default => :spec

desc "Run all specs in spec directory (excluding plugin specs)"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts = ['--options', File.join(File.dirname(__FILE__), 'spec', 'spec.opts')]
  t.spec_files = FileList['spec/**/*_spec.rb']
end

desc "Generate the gemspec file."
task :gemspec do
  require 'erb'

  File.open(gem_spec_file, 'w') do |f|
    f.write ERB.new(File.read("#{gem_spec_file}.erb")).result(binding)
  end
end
