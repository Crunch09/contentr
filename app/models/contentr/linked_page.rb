module Contentr
  class LinkedPage < Page

    # Includes
    include Rails.application.routes.url_helpers

    # Protect attributes from mass assignment

    # Validations

    # Public: find a LinkedPage by specific parameters
    #
    # params - A hash containing the following keys:
    #   controller
    #   action
    #   id (optional)
    #
    # Returns the found LinkedPage
    def self.find_by_request_params(params)
      controller = params[:controller]
      action     = params[:action]
      id         = params[:id]

      return if controller.blank?
      return if action.blank?

      wildcard_pattern = "#{controller}#*"
      default_pattern = "#{controller}##{action}"
      full_pattern = "#{default_pattern}:#{id}" if id.present?

      if full_pattern.present?
        page = LinkedPage.where(linked_to: full_pattern).try(:first)
        return page if page.present?
      end

      page = LinkedPage.where(linked_to: default_pattern).try(:first)
      return page if page.present?

      page = LinkedPage.where(linked_to: wildcard_pattern).try(:first)
      return page if page.present?
    end

  end
end
