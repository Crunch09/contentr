module Contentr
  module ApplicationHelper
    include Admin::ParagraphsHelper

    # Renders an area of paragraphs
    #
    # @param [String] The name of the area that should be rendered.
    #
    def contentr_area(area_name)
      raise "No area name given" if area_name.blank?
      contentr_render_area(area_name, @contentr_page) if @contentr_page.present?
    end

    # Renders an area of paragraphs for site paragraphs
    #
    # @param [String] The name of the area that should be rendered.
    #
    def contentr_site_area(area_name)
      raise "No area name given" if area_name.blank?
      contentr_render_area(area_name, Contentr::Site.default)
    end

    # Renders the contentr toolbar in the page
    def contentr_toolbar(options = {})
      if contentr_authorized?
        return render(
          partial: 'contentr/toolbar',
        )
      end
    end

    # Inserts Google Anylytics into the page
    def contentr_google_analytics
      if Contentr.google_analytics_account.present?
        render(
          partial: 'contentr/google_analytics',
          locals: {
            account_id: Contentr.google_analytics_account
          }
        )
      end
    end

    def contentr_paragraph_visible_icon(paragraph)
      if paragraph.visible?
        link_to "#{fa_icon('eye-slash')}".html_safe, contentr.hide_admin_paragraph_path(paragraph)
      else
        link_to "#{fa_icon('eye')}".html_safe, contentr.display_admin_paragraph_path(paragraph)
      end
    end

    def contentr_new_subpage_link(parent: nil)
      link_to fa_icon('plus', text: 'Neue Unterseite'), contentr.admin_sub_pages_path(id: @contentr_page, layout_type: 'embedded'), class: 'btn btn-danger show-page-in-iframe', rel: 'contentr-overlay', remote: true
    end

    private

    def contentr_render_area(area_name, page)
      area_name  = area_name.to_s
      authorized = contentr_authorized?
      publisher = contentr_publisher?
      paragraphs = page.paragraphs_for_area(area_name)
      render(
        partial: 'contentr/area',
        locals: {
          page: page,
          area_name: area_name,
          authorized: authorized,
          publisher: publisher,
          paragraphs: paragraphs
        }
      )
    end

    def show_frontend_subtree(subtree, children)
      return [] if children.empty?
      st = children.keys.collect do |nt|
        lic = content_tag(:li, :'data-id' => nt.id, class: 'dropdown-submenu') do
          st = show_frontend_subtree(nt, children[nt])
          if st.none?
            l = link_to nt.title, nt.link, class: 'real-link'
          else
            l = link_to nt.title.html_safe, '#', data: {toggle: 'dropdown'}, class: 'dropdown-toggle'
            l + st.join('').html_safe
          end
        end
        lic
      end
      if subtree.parent.nil?
        ul_class = 'nav'
      else
        ul_class = 'dropdown-menu'
      end
      st.prepend("<ul class='col-sm-4 tree #{ul_class}' data-parent='#{subtree.id}'>")
      st.append('</ul>')
      st
    end
  end
end
