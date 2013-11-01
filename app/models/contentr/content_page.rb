module Contentr
  class ContentPage < Page

    # Protect attributes from mass assignment
    permitted_attributes :layout, :template

    # Validations
    validates_presence_of :layout
    validates_presence_of :template
  end
end
