#  documentation on http://two.mongoid.org/docs/relations/referenced/1-n.html
class Search
  include Mongoid::Document
  
  field :body, type: String

  belongs_to :user
end
