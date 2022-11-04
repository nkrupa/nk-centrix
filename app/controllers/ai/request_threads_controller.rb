class Ai::RequestThreadsController < ApplicationController
  helper_method :current_threads,
                :current_thread

  def index
  end

  def show
  end

  private

  def current_thread
    Ai::RequestThread.find(params[:id])
  end

  def current_threads
    Ai::RequestThread.order(created_at: :desc)
  end
end
