# coding: utf-8

module Contentr
  module Admin
    module ApplicationHelper

      def simple_form_for_contentr_paragraph(paragraph, area_name, &block)
        simple_form_for(
          'paragraph',
          :url     => (paragraph.new_record? ? contentr.admin_paragraphs_path(area_name: area_name, type: paragraph.class) :
            contentr.admin_paragraph_path(paragraph)),
          :method  => (paragraph.new_record? ? :post : :patch),
          :enctype => "multipart/form-data",
          remote: true,
          data: {id: paragraph.try(:id)}) do |f|
            yield(f) # << f.input(:area_name, :as => :hidden)
          end
      end

      def simple_form_for_content_block_paragraph(paragraph, content_block, &block)
        simple_form_for(
          'paragraph',
          :url     => (paragraph.new_record? ? contentr.admin_content_block_paragraphs_path(content_block, type: paragraph.class) : contentr.admin_content_block_paragraph_path(content_block, paragraph)),
          :method  => (paragraph.new_record? ? :post : :patch),
          :enctype => "multipart/form-data",
          remote: true,
          data: {id: paragraph.try(:id)}) do |f|
            yield(f) # << f.input(:area_name, :as => :hidden)
          end
      end

      def simple_form_for_contentr_file(file, &block)
        simple_form_for(
          'file',
          :url     => (file.new_record? ? contentr.admin_files_path() : contentr.admin_file_path(file)),
          :method  => (file.new_record? ? :post : :put),
          :enctype => "multipart/form-data",
          :html    => {:class => 'form-horizontal'}) do |f|
            yield(f)
          end
      end

      def contentr_link_to_preview_for(page)
        params = {preview: true}.to_query
        url = page.url
        params = url['?'] ? params.prepend('&') : params.prepend('?')
        "#{page.url}#{params}"
      end

      def show_subtree(subtree)
        return [] if subtree['children'].empty?
        st = subtree['children'].collect do |nt|
          lic = content_tag(:li) do
            st = show_subtree(nt)
            "#{nt['title'].html_safe} #{st.join('').html_safe}".html_safe
          end
          lic
        end
        st.prepend('<ul>')
        st.append('</ul>')
        st
      end

      def test_html_safe
        content_tag(:li) do
          "#{'foo'} #{content_tag(:li){'bar'}}".html_safe
        end
      end
    end
  end
end
