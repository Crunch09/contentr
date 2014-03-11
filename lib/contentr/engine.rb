require 'bootstrap-sass'
require 'jquery-rails'
require 'compass-rails'
require 'tabulatr2'
require 'bootstrap-wysihtml5-rails'
require 'jquery-ui-rails'
require 'carrierwave'
require 'font-awesome-rails'

module Contentr

  class Engine < Rails::Engine

    initializer 'contentr rendering' do |app|
      require 'contentr/rendering'
      ActionController::Base.send :include, Contentr::Rendering
    end

    initializer 'contentr frontend editing' do |app|
      require 'contentr/frontend_editing'
      ActionController::Base.send :include, Contentr::FrontendEditing
    end

  end

end
