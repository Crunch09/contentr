# encoding: utf-8
class Contentr::Admin::ParagraphsController < Contentr::Admin::ApplicationController
  before_filter :find_page_or_site

  def index
    @paragraphs = @page.paragraphs.order_by(:area_name, :asc).order_by(:position, :asc)
  end

  def new
    @area_name = params[:area_name]
    if params[:type].present?
      @paragraph = paragraph_type_class.new(area_name: @area_name)
      render 'new', layout: false
    else
      render 'new_select'
    end
  end

  def create
    @paragraph = paragraph_type_class.new(paragraph_params)
    @paragraph.area_name = params[:area_name]
    @paragraph.page = @page
    @page_or_site.paragraphs << @paragraph
    if @page_or_site.save!
      if request.xhr?
        @paragraph = @paragraph.for_edit
        render action: 'show', layout: false
      else
        flash[:notice] = 'Paragraph created'
        redirect_to contentr.admin_pages_path(root: @page.id)
      end
    else
      render :action => :new
    end
  end

  def edit
    @paragraph = @page_or_site.paragraphs.find(params[:id])
    @paragraph.for_edit
    render action: 'edit', layout: false
  end

  def update
    @paragraph = @page_or_site.paragraphs.select { |p| p.id.to_s == params[:id] }.first
    if params[:paragraph].has_key?("remove_image")
      @paragraph.image_asset_wrapper_for(params[:paragraph]["remove_image"]).remove_file!(@paragraph)
      params[:paragraph].delete("remove_image")
    end
    if @paragraph.update(paragraph_params)
      if request.xhr?
        @paragraph = @paragraph.for_edit
        render action: 'show', layout: false
      else
        flash[:notice] = 'Paragraph saved'
        redirect_to contentr.admin_pages_path(root: @page.id)
      end
    else
      render :action => :edit
    end
  end

  def show
    @paragraph = @page_or_site.paragraphs.find(params[:id])
    @paragraph.for_edit
    render action: 'show', layout: false
  end

  def publish
    @paragraph = @page_or_site.paragraphs.find(params[:id])
    @paragraph.publish!
    flash[:notice] = "Published this paragraph"
    redirect_to :back
  end

  def revert
    @paragraph = @page_or_site.paragraphs.find(params[:id])
    @paragraph.revert!
    flash[:notice] = "Reverted this paragraph"
    redirect_to :back
  end

  def show_version
    @paragraph = @page_or_site.paragraphs.find(params[:id])
    current = params[:current] == "1" ? true : false
    render text: view_context.display_paragraph(@paragraph, current)
  end

  def destroy
    paragraph = @page_or_site.paragraphs.find(params[:id])
    paragraph.destroy
    flash[:error] = "Paragraph was destroyed"
    redirect_to :back
  end

  def reorder
    paragraphs_ids = params[:paragraph]
    paragraphs = @page_or_site.paragraphs_for_area(params[:area_name]).sort { |x,y| paragraphs_ids.index(x.id.to_s) <=> paragraphs_ids.index(y.id.to_s) }
    paragraphs.each_with_index { |p, i| p.update_column(:position, i) }
    head :ok
  end

  protected

  def paragraph_type_class
    paragraph_type_string = params[:type] # e.g. Contentr::HtmlParagraph
    paragraph_type_class = paragraph_type_string.classify.constantize # just to be sure
    paragraph_type_class if paragraph_type_class < Contentr::Paragraph
  end

  def find_page_or_site
    if (params[:site] == 'true')
      @page_or_site = Contentr::Site.default
      @page = Contentr::Page.find(params[:page_id])
    else
      @page_or_site = Contentr::Page.find(params[:page_id])
      @page = @page_or_site
    end
  end

  protected
    def paragraph_params
      type =  params['type'] || @page_or_site.paragraphs.select { |p| p.id.to_s == params[:id] }.first.class.name

      params.require(:paragraph).permit(*type.constantize.permitted_attributes)
    end

end
