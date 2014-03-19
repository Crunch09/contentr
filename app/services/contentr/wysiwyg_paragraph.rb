# coding: utf-8

module Contentr
  class WysiwygParagraph < Paragraph
    include ActionView::Helpers
    # Fields
    field :body, :type => 'text'
  end
end
