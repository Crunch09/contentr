class Contentr::PagesController < Contentr::ApplicationController

  def show
    @obj = params[:klass].constantize.find(params[:id])
    @contentr_page = @obj.sub_pages.find_by(slug: params[:args])

    if @contentr_page
      render action: 'show', layout: "layouts/#{@contentr_page.layout}"
    else
      render status: 404
    end
  end

end
