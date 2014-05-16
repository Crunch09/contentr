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
      @paragraph.publish! if paragraph_type_class.auto_publish
      if request.xhr?
        @paragraph = @paragraph.for_edit
        render action: 'show', layout: false
      else
        redirect_to :back, notice: 'Paragraph wurde erfolgreich erstellt'
      end
    else
      render :action => :new
    end
  end

  def edit
    @paragraph = Contentr::Paragraph.find_by(id: params[:id])
    @paragraph.for_edit
    render action: 'edit', layout: false
  end

  def update
    @paragraph = Contentr::Paragraph.unscoped.find(params[:id])
    if params[:paragraph].has_key?("remove_image")
      @paragraph.image_asset_wrapper_for(params[:paragraph]["remove_image"]).remove_file!(@paragraph)
      params[:paragraph].delete("remove_image")
    end
    if @paragraph.update(paragraph_params)
      if request.xhr?
        @paragraph = @paragraph.for_edit
        render action: 'show', layout: false
      else
        redirect_to :back, notice: 'Paragraph wurde erfolgreich aktualisiert.'
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
    @paragraph = Contentr::Paragraph.find_by(id: params[:id])
    @paragraph.publish!
    redirect_to(:back, notice: 'Published this paragraph')
  end

  def revert
    @paragraph = Contentr::Paragraph.find_by(id: params[:id])
    @paragraph.revert!
    redirect_to(:back, notice: 'Reverted this paragraph')
  end

  def show_version
    @paragraph = Contentr::Paragraph.find_by(id: params[:id])
    current = params[:current] == "1" ? true : false
    render text: view_context.display_paragraph(@paragraph, current)
  end

  def destroy
    paragraph = Contentr::Paragraph.find_by(id: params[:id])
    paragraph.destroy
    redirect_to :back, notice: 'Paragraph was destroyed'
  end

  def reorder
    paragraphs_ids = params[:paragraph]
    paragraphs = @page_or_site.paragraphs_for_area(params[:area_name]).sort { |x,y| paragraphs_ids.index(x.id.to_s) <=> paragraphs_ids.index(y.id.to_s) }
    paragraphs.each_with_index { |p, i| p.update_column(:position, i) }
    head :ok
  end

  def display
    paragraph = Contentr::Paragraph.find_by(id: params[:id])
    paragraph.update(visible: true)
    redirect_to :back, notice: t('.message')
  end

  def hide
    paragraph = Contentr::Paragraph.find_by(id: params[:id])
    paragraph.update(visible: false)
    redirect_to :back, notice: t('.message')
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
      @page = Contentr::Page.find_by(id: params[:page_id])
    else
      @page_or_site = Contentr::Page.find_by(id: params[:page_id])
      @page = @page_or_site
    end
  end

  protected
    def paragraph_params
      type =  params['type'] || Contentr::Paragraph.unscoped.find(params[:id]).class.name

      params.require(:paragraph).permit(*type.constantize.permitted_attributes)
    end

end
