require 'rails_helper'

RSpec.describe "Admin::HelpArticles", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/admin/help_articles/index"
      expect(response).to have_http_status(:success)
    end
  end

end
