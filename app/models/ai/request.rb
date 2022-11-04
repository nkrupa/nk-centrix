class Ai::Request < ApplicationRecord

  def parse_response
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


    self.response_text = self.response["choices"].map{|choice| choice["text"]}.join("\n")
    self.tokens_used = self.response["usage"]["total_tokens"].to_i
  end
end
