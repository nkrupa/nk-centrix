class Ai::RequestThreads::ThreadedRequestController < ApplicationController
  helper_method :current_thread

  def new
  end

  def create
  end

  private

  def current_thread
    Ai::RequestThread.find(params[:request_thread_id])
  end

end
