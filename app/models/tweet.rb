class Tweet
  include Mongoid::Document
  include Mongoid::Timestamps

  field :text, :type => String
  field :lang, :type =>String
  field :user, :type => Integer
  field :geo, :type => String
  field :retweeted, :type => Boolean

  attr_accessible :id, :term_id, :text, :lang, :user, :geo, :retweeted, :created_at, :updated_at

  belongs_to :term
end
