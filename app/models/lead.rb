class Lead
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user, :type => String
  field :contacted_at, :type => DateTime

  belongs_to :term
end
