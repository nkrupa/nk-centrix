class AiController < ApplicationController
  
  def show
  end

  def create
    @query = params[:query]

    @response = OpenAiClient.new.question(@query)
    render action: :show
  end

end
