require Rails.root.join("app/types/vector_type")
ActiveRecord::Type.register(:vector, VectorType)
