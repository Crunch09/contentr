class Contentr::Admin::PagesController < Contentr::Admin::ApplicationController
  before_filter :load_root_page

  layout 'application'

  def index
    @pages = @root_page.present? ? @root_page.children
                                 : Contentr::Site.all
    @page = @root_page.present? ? @root_page : nil
    # @contentr_page = @root_page.present? ? @root_page : Contentr::Site.default
    @contentr_page = @root_page.present? ? @root_page : nil
    tabulatr_for @pages
  end

  def new
    @default_page = Contentr::Page.find(params[:default_page])
    @page = Contentr::Page.new(language: params[:language])
    if @default_page.present?
      @page.page_in_default_language = @default_page
      @page.displayable = @default_page.displayable
      @page.parent = @default_page.parent
      @page.page_type = @default_page.page_type
    end
  end

  def create
    @page = Contentr::ContentPage.new(page_params)
    if @page.save
      Contentr::NavPoint.create!(title: @page.name, parent_page: @page.parent,
        page: @page) unless @page.page_in_default_language.present?
      redirect_to contentr.admin_page_path(@page), notice: 'Seite wurde erstellt.'
    else
      redirect_to :back, notice: @page.errors.full_messages.join
    end
  end

  def show
    @page = Contentr::Page.find(params[:id])
    if @page.is_a?(Contentr::PageWithoutContent)
      redirect_to contentr.admin_page_path(@page.parent)
      return
    end
    if @page.page_in_default_language.present?
      @default_page = @page.page_in_default_language
    else
      @default_page = @page
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
      params.require(:page).permit(:name, :parent_id, :published, :language, :layout,
        :displayable_type, :displayable_id, :slug, :page_type_id, :page_in_default_language_id)#*Contentr::Page.permitted_attributes)
    end

end
