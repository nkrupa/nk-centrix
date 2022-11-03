class AiController < ApplicationController
  helper_method :current_request

  def show

  end

  def create
    current_request.query = form_params[:query]
    current_request.response = mock_r#OpenAiClient.new.question(@query)
    current_request.parse_response
    current_request.save!

# raise "current_request: #{current_request}"
    render turbo_stream: turbo_stream.update("foo", partial: "ai/form")
  end

  def mock_r
{"id"=>"cmpl-68Tp56RPFVB26Y5Xv41KwdQCeAYHj",
     "object"=>"text_completion",
     "created"=>1667479283,
     "model"=>"text-davinci-001",
     "choices"=>
      [{"text"=>"\n\nThe capital of Alaska is Juneau.",
        "index"=>0,
        "logprobs"=>nil,
        "finish_reason"=>"stop"}],
     "usage"=>
      {"prompt_tokens"=>7, "completion_tokens"=>10, "total_tokens"=>17}}
  end

  def current_request
    @current_request ||= Ai::Request.new(session_id: session.id)
  end

  def form_params
    params["ai_request"].to_unsafe_hash
  end
end
