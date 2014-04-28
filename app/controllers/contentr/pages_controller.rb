class Contentr::PagesController < Contentr::ApplicationController

  def show
    @obj = params[:klass].constantize.find(params[:id])
    @contentr_page = @obj.sub_pages.find_by(slug: params[:args], language: I18n.locale)
    if @contentr_page.nil?
      @contentr_page = Contentr::Page.default_page_for_slug(params[:args])
      flash.now[:notice] = 'Content is not available in requested language!!' if @contentr_page
    end
    if @contentr_page
      @contentr_page.preview! if params[:preview] == 'true'
      render action: 'show', layout: "layouts/frontend/#{@contentr_page.layout}"
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

end
