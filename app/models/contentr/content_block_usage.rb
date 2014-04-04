class Contentr::ContentBlockUsage < ActiveRecord::Base
  belongs_to :content_block, class_name: 'Contentr::ContentBlock'
  belongs_to :page, class_name: 'Contentr::Page'
end
