class Term
  include Mongoid::Document
  include Mongoid::Timestamps
   
  field :description, :type => String
  field :keywords,   :type => String

  
  attr_accessible :description, :keywords, :created_at, :updated_at
  
  belongs_to :user
end
