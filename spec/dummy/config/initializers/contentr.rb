# coding: utf-8

Contentr.setup do |config|
  config.site_name    = 'My Dummy Site'
  config.default_page = 'home'
  config.default_areas = [:headline, :body]
  config.generated_page_areas = [:before_generated_content, :after_generated_content]
  config.available_grouped_nav_points = ['All articles']
  # config.default_site = 'cms'
  # config.google_analytics_account = ''
  # config.register_paragraph(Contentr::HtmlParagraph, 'Show some raw HTML content')
end

if Contentr::Site.table_exists?
  Rails.configuration.contentr.available_sites.each do |locale|
    site = Contentr::Site.find_or_create_by!(name: locale)
    Contentr::NavPoint.find_or_create_by!(title: locale, site: site)
  end
end
