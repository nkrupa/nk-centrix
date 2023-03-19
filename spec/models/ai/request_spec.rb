require 'rails_helper'

RSpec.describe Ai::Request, type: :model do

  # repurposed from API client
  describe '#parse_response' do 
    let(:response) do 
      {"id"=>"chatcmpl-6uYg7LWVcodlIF09EJR7F1ncsAGWi",
        "object"=>"chat.completion",
        "created"=>1678937691,
        "model"=>"gpt-3.5-turbo-0301",
        "usage"=>
          {"prompt_tokens"=>56, "completion_tokens"=>13, "total_tokens"=>69},
        "choices"=>
          [{"message"=>
            {"role"=>"assistant",
              "content"=>"Austin was founded on December 27, 1839."},
            "finish_reason"=>"stop",
            "index"=>0}]}  
    end
    it "maps the values correctly" do
      subject.response = response
      subject.parse_response

      expect(subject.response_text).to eq("Austin was founded on December 27, 1839.")
      expect(subject.tokens_used).to eq(69)
    end
  end
end
