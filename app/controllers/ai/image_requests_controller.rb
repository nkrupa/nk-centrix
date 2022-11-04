class Ai::ImageRequestsController < ApplicationController

  helper_method :current_request

  def new
  end

  def create
    current_request.save!
    current_request.generate!(query)
    redirect_to ai_image_request_path(current_request)
    # @current_request = current_request.add!(query)
  end

  def show
  end

  private

  def query
    params[:ai_image_generation_request][:query]
  end


  def current_request
    @current_request ||= params[:id] ? Ai::ImageGenerationRequest.find(params[:id]) : Ai::ImageGenerationRequest.new(session_id: session.id)
  end
end
