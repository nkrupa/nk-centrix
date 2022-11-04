class Ai::ThreadedRequestsController < ApplicationController
  helper_method :current_request

  def show
  end

  def debug
    render turbo_stream: turbo_stream.update(:thread_debug, partial: "ai/threaded_requests/debug", current_request: current_request)
  end

  private

  def current_request
    Ai::ThreadedRequest.find(params[:id])
  end

end
