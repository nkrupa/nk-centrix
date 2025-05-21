class MemoryEntry < ApplicationRecord
  attribute :embedding, VectorType.new

  def self.similar_to(text, top_k: 5)
    query_embedding = EmbeddingService.embed(text)
    vector_literal = "[#{query_embedding.join(',')}]"

    # This time, we interpolate the vector directly into the SQL string
    sql = <<~SQL.squish
      memory_entries.*, embedding <-> '#{vector_literal}'::vector AS distance
    SQL

    select(Arel.sql(sql))
      .order(Arel.sql("distance ASC"))
      .limit(top_k)
  end
end
