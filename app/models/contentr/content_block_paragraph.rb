module Contentr
  class ContentBlockParagraph < Paragraph
    auto_publish true

    field :selected_content_block, :type => 'String'
  end
end
