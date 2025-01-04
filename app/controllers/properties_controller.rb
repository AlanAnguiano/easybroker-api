class PropertiesController < ApplicationController
  def index
    page = permitted_params[:page]

    @properties_titles = fetch_properties_titles(page)
    return render json: @properties_titles, status: :ok if @properties_titles.present?

    render json: { error: "Internal server error" }, status: :internal_server_error
  end

  private

  def fetch_properties_titles(page)
    if page.nil? || page == 'all'
      eb_service.fetch_all_properties_titles
    else
      eb_service.fetch_properties_titles_per_page(page)
    end
  end

  def eb_service
    @eb_service ||= EasyBrokerService.new
  end

  def permitted_params
    params.permit(:page)
  end
end
