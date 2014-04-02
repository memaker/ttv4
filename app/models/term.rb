class Term
  include Mongoid::Document
  include Mongoid::Timestamps

  field :description, :type => String
  field :keywords,   :type => String
  field :searched_at, :type => DateTime
  field :last_id, :type => Integer

  attr_accessible :description, :keywords, :created_at, :updated_at, :searched_at, :last_id

  belongs_to :user, dependent: :nullify # http://mongoid.org/en/mongoid/docs/relations.html Dependent Behaviour
  has_many :tweets, dependent: :delete # http://mongoid.org/en/mongoid/docs/relations.html Dependent Behaviour
end
