Rails.application.routes.draw do
  get '/suggest', to: 'suggestions#index', defaults: { format: 'json' }, as: 'suggestions'
end
