module Contentr::BackendRouting
  def contentr_backend_routes
    scope '(:layout_type)', layout_type: /(admin)|(embedded)/, module: 'admin', as: :admin do
      root to: 'pages#index'
      resources :pages, except: [:index] do
        member do
          get :publish
          get :hide
          resources :sub_pages, only: [:index] do
            collection do
              patch :reorder
            end
          end
        end
        resources :paragraphs, only: [:show, :update, :index]
      end
      resources :sites
      resources :files
      resources :paragraphs, only: [:edit, :update, :destroy] do
        member do
          get :display
          get :hide
        end
      end
      resources :nav_points, only: [:index, :new, :create, :edit, :update, :destroy]
      resources :page_types, only: [:new, :create, :index, :edit, :update]
      resources :content_blocks, only: [:new, :create, :edit, :update, :index] do
        resources :paragraphs, only: [:new, :create, :index], controller: 'content_block/paragraphs' do
          collection do
            patch 'reorder' => 'content_block/paragraphs#reorder'
          end
        end
      end
      resources :content_block_usages, only: [:create]
      patch    'pages/:page_id/area/:area_name/paragraphs/reorder'     => 'paragraphs#reorder', :as => 'reorder_paragraphs'
      get    'pages/:page_id/area/:area_name/paragraphs/(:type)/new' => 'paragraphs#new',     :as => 'new_paragraph'
      post   'pages/:page_id/area/:area_name/paragraphs/:type'       => 'paragraphs#create',  :as => 'paragraphs'
      # get    'pages/:page_id/paragraphs'           => 'paragraphs#index',   :as => 'page_paragraphs'
      # get    'pages/:page_id/paragraphs/:id/edit'  => 'paragraphs#edit',    :as => 'edit_paragraph'
      # get    'pages/:page_id/paragraphs/:id'      => 'paragraphs#show',    as: 'paragraph'
      get    'paragraphs/:id/publish' => 'paragraphs#publish', :as => 'publish_paragraph'
      get    'paragraphs/:id/revert' => 'paragraphs#revert', :as => 'revert_paragraph'
      get    'paragraphs/:id/show_version/:current' => 'paragraphs#show_version', as: 'show_version'
      # patch    'pages/:page_id/paragraphs/:id'       => 'paragraphs#update',  :as => 'paragraph'
      # delete 'pages/:page_id/paragraphs/:id'       => 'paragraphs#destroy', :as => 'paragraph_destroy'
    end
  end
end
