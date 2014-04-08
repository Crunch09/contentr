class Contentr::Admin::NavPointsController < Contentr::Admin::ApplicationController
  layout 'application'
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

  def destroy
    @nav_point = Contentr::NavPoint.find(params[:id])
    @nav_point.destroy
    redirect_to action: 'index'
  end
  private

  def nav_point_params
    params.require(:nav_point).permit(:title, :parent_id)
  end
end
