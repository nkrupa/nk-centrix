class AiRequestsController < ApplicationController
  helper_method :current_requests

  def index
    @current_requests = Ai::Request.order(created_at: :desc)
  end

  attr_reader :current_requests
end
