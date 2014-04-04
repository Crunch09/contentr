module Contentr
  class ContentBlock < ActiveRecord::Base
    has_many :content_block_usages, class_name: 'Contentr::ContentBlockUsage'
    has_many :pages, class_name: 'Contentr::Page', through: :content_block_usages
    has_many :paragraphs, dependent: :destroy, before_add: :set_actual_position,
             inverse_of: :content_block, class_name: 'Contentr::Paragraph'

    validates :language, presence: true
    validates :name, presence: true
    validate :partial_xor_paragraphs

    def set_actual_position(paragraph)
      last_position = Contentr::Paragraph.order('position DESC').find_by(content_block: self)
      if last_position
        paragraph.position = last_position.position + 1
      end
    end

    # Public: Searches for all paragraphs with an exact area_name
    #
    # area_name - the area_name to search for
    #
    # Returns the matching paragraphs
    def paragraphs_for_area(area_name)
      paragraphs = self.paragraphs.order("position asc")
      paragraphs
    end

    def self.available_partials
      Dir.glob("#{Rails.root}/app/views/contentr/content_blocks/**/*").map do |partial|
        partial.scan(/\/app\/views\/contentr\/content_blocks\/(.*)\.html.*\z/){|match| return match}
      end
    end

    private

    def partial_xor_paragraphs
      if [partial, paragraphs].compact.select(&:present?).count > 1
        errors.add(:partial, :partial_and_paragraphs_are_mutual_exclusive)
      end
    end
  end
end
