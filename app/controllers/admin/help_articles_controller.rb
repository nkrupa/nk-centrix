module Admin
  class HelpArticlesController < ApplicationController
    def index
      if params[:query].present?
        @distance = params[:distance]&.to_f || 0.2
        @help_articles = HelpArticle.similar_to(params[:query], top_k: 10)
        @query = params[:query]
      else
        @help_articles = HelpArticle.order(created_at: :desc).limit(50)
      end
    end
  end
end
