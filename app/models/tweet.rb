class Tweet
  include Mongoid::Document
  include Mongoid::Timestamps

  field :text, :type => String
  field :lang, :type =>String
  field :user, :type => Integer
  field :geo, :type => String
  field :retweeted, :type => Boolean
  field :gender, :type =>  String

  attr_accessible :id, :term_id, :text, :lang, :user, :geo, :retweeted, :gender, :created_at, :updated_at

  belongs_to :term
end
