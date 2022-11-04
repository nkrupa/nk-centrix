require 'rails_helper'

RSpec.describe OpenAiClient, type: :model do
  let(:completions_response) { {} }

  let(:client) do 
    double(:client, completions: completions_response)
  end

  subject { OpenAiClient.new(client: client) }

  describe '#question' do 
    let(:completions_response) do 
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

    specify do
      expect(subject.question("What is the capital of Alaska?")).to eq(completions_response)
    end
  end

  describe '#chat' do 
    let(:completions_response) do 
      {"id"=>"cmpl-68Tp56RPFVB26Y5Xv41KwdQCeAYHj",
       "object"=>"text_completion",
       "created"=>1667479283,
       "model"=>"text-davinci-001",
       "choices"=>
        [{"text"=>"?\n\nAI: I'm fabulous! How are you?",
          "index"=>0,
          "logprobs"=>nil,
          "finish_reason"=>"stop"}],
       "usage"=>
        {"prompt_tokens"=>7, "completion_tokens"=>10, "total_tokens"=>17}}  
    end

    specify do
      expect(subject.chat("What is your name?")).to eq(completions_response)
    end
  end

  describe '#format_question' do 
    it "writes" do
      expect(subject.format_question("How are you?  ")).to eq("How are you?")
    end
  end
end
