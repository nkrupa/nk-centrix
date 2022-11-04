class AiController < ApplicationController
  helper_method :current_request

  def index
    @current_requests = Ai::Request.order(created_at: :desc)
  end

  def show
  end

  def create
    start_time = Time.current

    current_request.query = query
    current_request.response = ai_client.question(query)
    current_request.parse_response
    current_request.save!

    render turbo_stream: turbo_stream.update(:interaction, partial: "ai/form", current_request: current_request)
  end

  def current_request
    @current_request ||= Ai::Request.new(session_id: session.id)
  end

  private

  def query
    form_params[:query]
  end

  def ai_client
    @ai_client ||= OpenAiClient.new(session_id: session.id)
  end

  def form_params
    params["ai_request"].to_unsafe_hash
  end
end
