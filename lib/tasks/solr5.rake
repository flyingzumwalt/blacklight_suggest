##
# Solr 5.x (solr_wrapper)
#

SOLR_OPTIONS = {
    verbose: true,
    cloud: true,
    port: '8888',
    version: '5.3.1',
    instance_dir: 'solr',
    download_dir: 'tmp'
}

SOLR_OPTIONS[:port] = '8983' if ENV['RAILS_ENV'] == 'development'

require 'solr_wrapper/rake_task'  # solr_wrapper for solr5

namespace :solr5 do

  task :clean do
    Rake::Task['solr:clean'].invoke
  end
  task :start do
    Rake::Task['solr:start'].invoke
  end
  task :stop do
    Rake::Task['solr:stop'].invoke
  end

  desc 'Run this when solr is running! add searchComponents and requestHandlers to solrConfig in solr5'
  task :config do
    puts "   creating blacklight-core collection"
    SolrWrapper.default_instance(SOLR_OPTIONS).create(name: 'blacklight-core', dir: File.join('sample_solr_configs','solr5'))
  end

  desc "Execute Continuous Integration build with solr 5"
  task :ci => ['engine_cart:generate'] do
    require 'solr_wrapper'

    error = SolrWrapper.wrap(SOLR_OPTIONS) do |solr|
      # Rake::Task['solr5:config']
      solr.with_collection(dir: File.join('sample_solr_configs','solr5'), name:'blacklight-core') do |collection_name|
        Rake::Task['spec'].invoke
      end
    end

    raise "test failures: #{error}" if error
  end

end