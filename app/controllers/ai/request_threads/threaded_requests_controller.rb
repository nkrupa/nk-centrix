class Ai::RequestThreads::ThreadedRequestsController < ApplicationController
  helper_method :current_thread

  def create
    @current_request = current_thread.add!(query)
  end

  private

  def query
    params[:ai_threaded_request][:query]
  end

  def current_thread
    @current_thread ||= Ai::RequestThread.find(params[:request_thread_id])
  end

end
