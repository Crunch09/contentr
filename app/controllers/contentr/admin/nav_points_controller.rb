class Contentr::Admin::NavPointsController < Contentr::Admin::ApplicationController

  def index
    @nav_tree = Contentr::NavPoint.navigation_tree
  end

  def new
    @nav_point = Contentr::NavPoint.new(parent_id: params[:parent])
  end

  def create
    @nav_point = Contentr::NavPoint.new(nav_point_params)
    if @nav_point.save
      redirect_to contentr.admin_nav_points_path
    else
      render action: 'new', notice: 'save failed'
    end
  end

  def edit
    @nav_point = Contentr::NavPoint.eager_load(:page).find(params[:id])
    @nav_point.set_tag_from_page
    @page = @nav_point.page
  end

  def update
    @nav_point = Contentr::NavPoint.find(params[:id])
    if @nav_point.update(nav_point_params)
      redirect_to(:back, notice: 'Navigationspunkt wurde aktualisiert')
    else
      render({action: :edit}, alert: 'Navigationspunkt konnte nicht gespeichert werden')
    end
  end

  def destroy
    @nav_point = Contentr::NavPoint.find(params[:id])
    @nav_point.destroy
    redirect_to action: 'index'
  end
  private

  def nav_point_params
    params.require(:nav_point).permit(:title, :parent_id, :url, :page_tag, :en_title, :visible)
  end

end
