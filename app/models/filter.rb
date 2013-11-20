class Filter
  include Mongoid::Document
  field :key, type: String
  field :value, type: String
  field :type, type: String
end
