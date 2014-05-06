class Contentr::Admin::ApplicationController < Contentr::ApplicationController

  before_action :check_authorization
  before_action :set_layout

  before_filter do
    Contentr.layout_type = params[:layout_type] || 'admin'
  end

  def check_authorization
    redirect_to main_app.root_path unless contentr_authorized?
  end

  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { layout_type: (Contentr.layout_type || 'admin') }
  end
  protected
    def contentr_authorized?
      true # In a real app override this
    end

    def set_layout
      if params[:layout_type] == 'embedded' 
        self.class.layout 'embedded'
      else
        self.class.layout 'application'
      end
    end
end
