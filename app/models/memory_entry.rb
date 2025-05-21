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

  def self.recall_context(query_text, top_k: 5, session_id: nil)
    query_embedding = EmbeddingService.embed(query_text)
    vector_literal = "[#{query_embedding.join(',')}]"

    scope = all
    scope = scope.where(session_id: session_id) if session_id

    scope.select(
      Arel.sql("memory_entries.*, embedding <-> '#{vector_literal}'::vector AS distance")
    ).order(Arel.sql("distance ASC")).limit(top_k)
  end
end
