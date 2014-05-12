class Lead
  include Mongoid::Document
  field :user, :type => String

  belongs_to :term
end
