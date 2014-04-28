module Contentr::FrontendRouting
  def contentr_frontend_routes
    get 'file/:slug' => 'contentr/files#show'
  end

  def contentr_frontend_routes_for(klass)
    get 'seiten/*args', to: 'contentr/pages#show', defaults: {klass: klass}
  end
end
