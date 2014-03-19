module Contentr
  class NavPoint < ActiveRecord::Base
    self.table_name = 'contentr_nav_points'

    belongs_to :site, class_name: 'Contentr::Site'
    belongs_to :displayable, polymorphic: true

    validate :site, presence: true

    acts_as_tree

    def only_link?
      self.displayable.nil?
    end
  end
end
