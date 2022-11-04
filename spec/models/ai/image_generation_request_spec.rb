require 'rails_helper'

RSpec.describe Ai::ImageGenerationRequest, type: :model do

  describe "#generate!" do
    subject { Ai::ImageGenerationRequest.create!(session_id: SecureRandom.uuid) }
    let(:base64_response) { JSON.parse(File.open(Rails.root.join("data", "sample_base64_image_response.json")).read) }

    it "loads" do 
      expect_any_instance_of(OpenAiClient).to receive(:generate_image!).and_return(base64_response)

      expect { subject.generate!("A happy cat") }.to change(subject.images, :count).by(1)

      image = subject.images.first

      expect(image.base64).to be_present
      expect(image.base64).to eq(base64_response["data"][0]["b64_json"])

    end

  end
end
