##
# Solr 4.x (jettywrapper)
#
ZIP_URL = "https://github.com/projectblacklight/blacklight-jetty/archive/v4.10.3.zip"

require 'jettywrapper' # jettywrapper for solr4

namespace :solr4 do

  task :clean do
    Rake::Task['jetty:clean'].invoke
  end
  task :start do
    Rake::Task['jetty:start'].invoke
  end
  task :stop do
    Rake::Task['jetty:stop'].invoke
  end

  desc 'add support for search and spellcheck to solrConfig and solr schema in solr4 (jetty)'
  task :config do
    FileList['sample_solr_configs/solr4/*'].each do |f|
      cp("#{f}", 'jetty/solr/blacklight-core/conf/', verbose: true)
    end
  end

  desc "Execute Continuous Integration build with solr 4"
  task :ci => ['jetty:clean', 'solr4:config', 'engine_cart:generate'] do

    jetty_params = {
        :jetty_home => File.expand_path(File.dirname(__FILE__) + '/jetty'),
        :quiet => false,
        :jetty_port => 8888,
        :solr_home => File.expand_path(File.dirname(__FILE__) + '/jetty/solr'),
        :startup_wait => 30
    }

    error = Jettywrapper.wrap(jetty_params) do
      Rake::Task['spec'].invoke
    end
    raise "test failures: #{error}" if error
  end
end
