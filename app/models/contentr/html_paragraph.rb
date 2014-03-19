# coding: utf-8

module Contentr
  class HtmlParagraph < Paragraph
    include ActionView::Helpers
    # Fields
    field :body, :type => 'String'

    # Validations
  end
end
