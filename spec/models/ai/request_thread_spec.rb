require 'rails_helper'

RSpec.describe Ai::RequestThread, type: :model do

  let(:chat_response) do 
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

  let(:client) do 
    double(:client, 
      completions: { completions_success: true },
      chat: chat_response)
  end

  before do 
    allow(OpenAiClient).to receive(:new).and_return(client)
  end

  describe '#add!' do 
    subject { Ai::RequestThread.create!(session_id: SecureRandom.uuid) }

    context "when none exist" do
      it "adds the expected request" do
        expect { subject.add!("Hi!") }.to change(subject.requests, :count).by(1)

        created_request = subject.requests.last
        puts subject.inspect
      end
    end

    context "when prior request exists" do 
      let!(:prior_thread) do 
        subject.requests.create!(
         query: "Hi!",
         session_id: subject.session_id,
         full_prompt:
          "The following is a conversation with an AI assistant. The assistant is helpful, creative, clever, and very friendly.\n" +
          "\n" +
          "Human: Hello, who are you?\n" +
          "AI: I am an AI created by OpenAI. How can I help you today?\n" +
          "Human: Hi!",
         response:
          {"id"=>"cmpl-68Tp56RPFVB26Y5Xv41KwdQCeAYHj",
           "model"=>"text-davinci-001",
           "usage"=>
            {"total_tokens"=>"[FILTERED]",
             "prompt_tokens"=>"[FILTERED]",
             "completion_tokens"=>"[FILTERED]"},
           "object"=>"text_completion",
           "choices"=>
            [{"text"=>"?\n" + "\n" + "AI: I'm fabulous! How are you?",
              "index"=>0,
              "logprobs"=>nil,
              "finish_reason"=>"stop"}],
           "created"=>1667479283},
         response_text: "?\n" + "\n" + "AI: I'm fabulous! How are you?",
         tokens_used: 14)

      end

      it "appends as expected" do
        expect(subject.requests.count).to eq(1)
        expect { subject.add!("I'm doing so well!") }.to change(subject.requests, :count).by(1)
        created_request = subject.requests.order(:created_at).last
      end
    end

  end
end
