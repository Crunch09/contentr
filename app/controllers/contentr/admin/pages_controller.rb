class Contentr::Admin::PagesController < Contentr::Admin::ApplicationController
  before_filter :load_root_page

  def index
    @pages = @root_page.present? ? @root_page.children
                                 : Contentr::Site.all
    @page = @root_page.present? ? @root_page : nil
    # @contentr_page = @root_page.present? ? @root_page : Contentr::Site.default
    @contentr_page = @root_page.present? ? @root_page : nil
    tabulatr_for @pages
  end

  def new
    @page = Contentr::ContentPage.new
  end

  def create
    @page = Contentr::ContentPage.new(page_params)
    if @page.save
      redirect_to :back, notice: 'Seite wurde erstellt.'
    else
      render :action => :new
    end
  end

  def show
    @page = Contentr::Page.find(params[:id])
    if @page.is_a?(Contentr::PageWithoutContent)
      redirect_to contentr.admin_page_path(@page.parent)
      return
    end
    if @page.displayable
      @parent_of_custom_pages = @page.displayable.parent_of_custom_pages
    end
    render action: 'show', layout: 'application'
  end

  def edit
    @page = Contentr::Page.find(params[:id])
    @contentr_page = Contentr::Page.find(params[:id])
  end

  def update
    @page = Contentr::Page.find(params[:id])
    if @page.update(page_params)
      flash[:success] = 'Page updated.'
      redirect_to contentr.admin_pages_path(:root => @page.root)
    else
      render :action => :edit
    end
  end

  def destroy
    page = Contentr::Page.find(params[:id])
    page.destroy
    redirect_to contentr.admin_pages_path(:root => @root_page)
  end

  def publish
    page = Contentr::Page.find(params[:id])
    page.publish!
    redirect_to :back, notice: 'Seite wurde veröffentlicht'
  end

  def hide
    page = Contentr::Page.find(params[:id])
    page.hide!
    redirect_to :back, notice: 'Seite ist jetzt verborgen'
  end

  private

  def load_root_page
    @root_page = Contentr::Page.find(params[:root]) if params[:root].present?
  end

  protected
    def page_params
      params.require(:page).permit(:name, :parent_id)#*Contentr::Page.permitted_attributes)
    end

end
