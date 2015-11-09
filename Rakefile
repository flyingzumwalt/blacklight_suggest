begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rdoc/task'
require 'engine_cart/rake_task'
require 'rspec/core/rake_task'

# load all of the tasks from lib/tasks
Dir[File.expand_path(File.join(File.dirname(__FILE__),'lib', 'tasks', '*.rake'))].each { |ext| load ext } if defined?(Rake)

task default: 'ci:all'

desc "Run specs"
RSpec::Core::RakeTask.new {|t|}

namespace :ci do
  desc 'Run the ci build for both solr4 and solr5'
  task :all do
    Rake::Task['solr4:ci'].invoke
    Rake::Task['solr5:ci'].invoke
  end
end

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'BlacklightSuggest'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
