class Contentr::ContentBlockTabulatrData < Tabulatr::Data
  column :name
  column :actions, table_column_options: {sortable: false, filter: false} do |content_block|
    links = [link_to(fa_icon(:wrench), contentr.edit_admin_content_block_path(content_block))]
    unless content_block.partial.present?
      links.push(link_to(fa_icon('list-alt'), contentr.admin_content_block_paragraphs_path(content_block)))
    end
    links
  end
  association :usages, :count, table_column_options: {sortable: false, filter: false}
end
