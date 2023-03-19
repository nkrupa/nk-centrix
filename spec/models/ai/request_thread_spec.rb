require 'rails_helper'

RSpec.describe Ai::RequestThread, type: :model do

  let(:client) do 
    double(:client, chat: chat_response)
  end

  before do 
    allow(OpenAiClient).to receive(:new).and_return(client)
  end

  describe '#add!' do 
    subject { Ai::RequestThread.create!(session_id: SecureRandom.uuid) }

    context "when no prior requests exist" do
      let(:prompt) { "What year was the treaty of Ghent?" }
      let(:chat_response) do
        {"id"=>"chatcmpl-6uYtaPOADHGt5pAcqXO3mOgKJKSWl",
          "object"=>"chat.completion",
          "created"=>1678938526,
          "model"=>"gpt-3.5-turbo-0301",
          "usage"=>
           {"prompt_tokens"=>16, "completion_tokens"=>17, "total_tokens"=>33},
          "choices"=>
           [{"message"=>
              {"role"=>"assistant",
               "content"=>
                "\n\nThe Treaty of Ghent was signed on December 24, 1814."},
             "finish_reason"=>"stop",
             "index"=>0}]}         
      end

      it "parses the response and builds the messages list" do
        expect { subject.add!(prompt) }.to change(subject.requests, :count).by(1)

        created_request = subject.requests.last
        expect(created_request.response_text).to eq("\n\nThe Treaty of Ghent was signed on December 24, 1814.")
        expect(subject.messages).to eq(
          [{ "role"=>"user", "content"=>prompt },
           { "role"=>"assistant", "content"=>"\n\nThe Treaty of Ghent was signed on December 24, 1814."},
          ]
        )
        puts subject.inspect
      end
    end

    context "when prior request exists" do 
      let(:session_id) { SecureRandom.uuid }
      let(:chat_response) do 
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
      let(:prior_messages) do 
        [
          { "role"=>"user", "content"=>"Hello" },
          { "role"=>"assistant", "content"=>"Hello! How can I assist you today?" },
          { "role"=>"user", "content"=>"What is the capital of Texas?" },
          { "role"=>"assistant", "content"=>"The capital of Texas is Austin."},
        ]
      end
      let(:prompt) { "When was it founded?" }

      subject { described_class.create!(session_id: session_id, messages: prior_messages) }


      # note, it would probably be more accurate to hand-roll request/responses for prior
      # requests in the thread
      it "creates a new request and appends to the request_thread" do
        expect { subject.add!(prompt) }.to change(subject.requests, :count).by(1)
        request = subject.requests.order(:created_at).last

        expect(request.session_id).to eq(session_id)
        expect(request.query).to eq(prompt)
        expect(request.response).to eq(chat_response)
        subject.reload
        expect(subject.messages).to eq(
          [
            { "role"=>"user", "content"=>"Hello" },
            { "role"=>"assistant", "content"=>"Hello! How can I assist you today?" },
            { "role"=>"user", "content"=>"What is the capital of Texas?" },
            { "role"=>"assistant", "content"=>"The capital of Texas is Austin."},
            { "role"=>"user", "content"=>prompt },
            { "role"=>"assistant", "content"=>"Austin was founded on December 27, 1839."},
          ]
        )
      end
    end

  end
end
