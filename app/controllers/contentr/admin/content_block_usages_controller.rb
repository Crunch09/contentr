class Contentr::Admin::ContentBlockUsagesController < Contentr::Admin::ApplicationController
  layout false
  def create
    @content_block_usage = Contentr::ContentBlockUsage.create!(content_block_usage_params)
  end

  private

  def content_block_usage_params
    params.require(:content_block_usage).permit(:content_block_id, :page_id,
      :area_name, :position)
  end
end
