require 'rails/generators'

module CurationConcerns
  class Install < Rails::Generators::Base

    def inject_routes
      inject_into_file 'config/routes.rb', after: /Rails.application.routes.draw do\n/ do
        "  get '/suggest', to: 'suggestions#index', defaults: { format: 'json' }"
      end
    end

  end
end
