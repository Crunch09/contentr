# coding: utf-8

module Contentr
  module Admin
    module ParagraphsHelper

      def display_paragraph(p, current = true)
        case p
        when Contentr::HtmlParagraph
          p = p.for_edit if contentr_publisher? && current
          s = p.body.html_safe if p.body
          s
        else
          p = p.for_edit if contentr_publisher? && current
          render(partial: "contentr/paragraphs/#{p.class.to_s.underscore}", locals: {paragraph: p})
        end
      end
    end
  end
end
