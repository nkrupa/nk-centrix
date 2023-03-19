require 'rails_helper'

RSpec.describe OpenAiClient, type: :model do
  let(:completions_response) { {} }

  let(:client) do 
    double(:client, chat: completions_response)
  end

  subject { OpenAiClient.new(client: client) }

  describe '#chat' do 
    let(:prior_messages) do 
      [
        { "role"=>"user", "content"=>"Hello" },
        { "role"=>"assistant", "content"=>"Hello! How can I assist you today?" },
        { "role"=>"user", "content"=>"What is the capital of Texas?" },
        { "role"=>"assistant", "content"=>"The capital of Texas is Austin."},
      ]
        
    end
    let(:completions_response) do 
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

    specify do
      expect(subject.chat "When was it founded?", messages: prior_messages).to eq(completions_response)
    end
  end

  describe '#format_question' do 
    it "writes" do
      expect(subject.format_question("How are you?  ")).to eq("How are you?")
    end
  end
end
