MmCms::Application.routes.draw do

  scope '/cms', :module => 'mm_cms' do
    # Admin
    namespace :admin do
      devise_for :users, :class_name => 'MmCms::User'
    end

    # Render frontend pages
    get '/(*path)' => 'pages#show', :as => 'cms'
  end

  root :to => 'application#index'

end
