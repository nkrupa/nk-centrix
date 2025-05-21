class HelpArticle < ApplicationRecord
  attribute :embedding, VectorType.new

  def self.similar_to(text, top_k: 5, max_distance: 1.2)
    query_embedding = EmbeddingService.embed(text)
    vector_literal = "[#{query_embedding.join(',')}]"

    where(
      Arel.sql("embedding <-> '#{vector_literal}'::vector < #{max_distance}")
    ).select(
      Arel.sql("help_articles.*, embedding <-> '#{vector_literal}'::vector AS distance")
    ).order("distance ASC").limit(top_k)
  end
end
