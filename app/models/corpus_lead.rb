class CorpusLead
  include Mongoid::Document
  field :tweet, type: String
  field :leadorno, type: String
end
