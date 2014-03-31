module Contentr
  class ContentPage < Page

    # Protect attributes from mass assignment
    permitted_attributes :layout

    # Validations
    validates_presence_of :layout
  end
end
