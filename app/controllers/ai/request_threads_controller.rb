class Ai::RequestThreadsController < ApplicationController
  helper_method :current_threads,
                :current_thread

  def index
  end

  def create
    @current_thread = Ai::RequestThread.create!(session_id: session.id)
    redirect_to ai_request_thread_path(@current_thread)
  end

  def show
  end

  private

  def current_thread
    @current_thread ||= Ai::RequestThread.find(params[:id])
  end

  def current_threads
    @current_threads ||= Ai::RequestThread.joins(:requests).order(created_at: :desc)
  end
end
