module Contentr
  class PageType < ActiveRecord::Base

    has_many :pages, class_name: 'Contentr::Page'

    validate :columns_have_correct_count
    validates :name, presence: true

    private

    def columns_have_correct_count
      if((self.col1_width || 0) + (self.col2_width || 0) + (self.col3_width || 0) +
         (self.col1_offset || 0) + (self.col2_offset || 0) + (self.col3_offset || 0) != 20)
        errors.add(:base, "combined column width + offset should be 20")
      end
    end
  end
end
