class HelpArticle < ApplicationRecord
  attribute :embedding, VectorType.new

  def self.similar_to(text, top_k: 5)
    query_embedding = EmbeddingService.embed(text)
    vector_literal = "[#{query_embedding.join(',')}]"

    select(Arel.sql("help_articles.*, embedding <-> '#{vector_literal}'::vector AS distance"))
      .order(Arel.sql("distance ASC"))
      .limit(top_k)
  end
end
