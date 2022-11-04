require 'rails_helper'

RSpec.describe Ai::Request, type: :model do

  describe "#parse_text" do 
    it "trims leading text" do
      original = "\n\nThe capital of Alaska is Juneau."
      expect(subject.parse_text(original)).to eq(original) 
    end

    it "trims leading text" do
      original = ".\n\n\n\nAI:\n\nJacksonville is"
      expect(subject.parse_text(original)).to eq("Jacksonville is") 
    end

  end
end
