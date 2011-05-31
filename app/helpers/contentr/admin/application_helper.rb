# coding: utf-8

module Contentr
  module Admin
    module ApplicationHelper

      def sitemap
        # render function
        fn = lambda do |pages|
          # pagees present?
          return '' unless pages.present?

          # render the ul tag
          content_tag(:ul) do
            pages.each_with_index.collect do |page, index|
              # options for the li tag
              li_options = {}
              # css classes
              css_classes = []
              # each li is an item
              css_classes << "item"
              # set the link css classes
              li_options[:class] = css_classes.join(' ')

              # render li tag
              content_tag(:li, li_options) do
                # default
                s = ''.html_safe
                # the link
                s << link_to(page.name, '#')
                # tools
                s << '   '
                s << link_to('[x]', contentr_admin_page_url(page), :method => :delete, :confirm => 'Really delete this page?')
                if page.is_link?
                  s << '   '
                  s << "(Linked to: #{page.linked_to})"
                end
                # the children
                s << fn.call(page.children)
              end
            end.join('').html_safe
          end
        end

        # render yo
        roots = Contentr::Page.roots.asc(:position)
        fn.call(roots)
      end

    end
  end
end