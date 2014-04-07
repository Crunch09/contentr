module Contentr
  class ContentBlockParagraph < Paragraph
    belongs_to :content_block_to_display, class_name: 'Contentr::ContentBlock'

    auto_publish true
  end
end
