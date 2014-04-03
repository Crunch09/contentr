Contentr::Engine.routes.draw do

  # admin
  namespace :admin do
    root to: 'pages#index'
    resources :pages do
      member do
        get :publish
        get :hide
      end
      resources :paragraphs, only: [:show, :update, :index]
    end
    resources :sites
    resources :files
    resources :paragraphs, only: [:edit, :update, :destroy]
    resources :nav_points, only: [:index]
    resources :page_types, only: [:new, :create, :index, :edit, :update]
    resources :content_blocks, only: [:new, :create, :edit, :update] do
      resources :paragraphs, only: [:new, :create, :index], controller: 'content_block/paragraphs' do
        collection do
          patch 'reorder' => 'content_block/paragraphs#reorder'
        end
      end
    end
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

  # frontend
  # resources :sites, only: [:show]
  get 'file/:slug' => 'files#show'

  # get '*contentr_path' => 'contentr/pages#show', :as => 'contentr'
end
