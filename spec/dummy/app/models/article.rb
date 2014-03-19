class Article < ActiveRecord::Base
  include Contentr::Contentrable

  validates_presence_of :title
  validates_presence_of :body

  permitted_attributes :title, :body

end
