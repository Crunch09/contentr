require 'spec_helper'

describe Contentr::GroupedNavPoint do
  it 'works' do
    site = create(:site, name: 'en')
    grouped_nav_point = create(:grouped_nav_point, title: 'All articles')
    article = create(:article, title: 'first one')

  end
end
