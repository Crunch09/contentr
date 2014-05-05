class Contentr::PagesController < Contentr::ApplicationController

  def show
    @obj = params[:klass].constantize.find(params[:id])
    if @obj.default_page.present?
      @contentr_page = @obj.sub_pages.find_by(slug: params[:args])
      @root_obj = @obj.default_page
    else
      @contentr_page = @root_obj = nil
    end
    if @contentr_page.present?
      @page_to_display = @contentr_page.get_page_for_language(I18n.locale)
      if @page_to_display.present?
        if I18n.locale.to_s != @contentr_page.language
          flash.now[:notice] = 'Content is not available in requested language!!' if @contentr_page
        end
        @page_to_display.preview! if params[:preview] == 'true'
        render action: 'show', layout: "layouts/#{@page_to_display.layout}"
        return
      end
    end
    raise ActionController::RoutingError.new('Not Found')
  end

end
