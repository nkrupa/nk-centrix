class VectorType < ActiveRecord::Type::Value
  def cast(value)
    case value
    when String
      # parse from '[0.1,0.2,0.3]' to [0.1, 0.2, 0.3]
      value.gsub(/[\[\]]/, '').split(',').map(&:to_f)
    when Array
      value.map(&:to_f)
    else
      []
    end
  end

  def serialize(value)
    return if value.nil?
    "[#{Array(value).join(',')}]"
  end
end
