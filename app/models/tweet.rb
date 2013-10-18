class Tweet
  include Mongoid::Document
  include Mongoid::Timestamps
  #include TweetsPerHour # map reduce module


  field :name, :type => String
  field :username, :type => String
  field :user_id, :type => Integer
  field :tweeted_at, :type => Time
  field :lang, :type =>String
  field :country_code, :type => String
#  field :geo_enabled, :type => Boolean
#  field :coordinates, :type => String
  field :location, :type => String #Not found for now
  field :text, :type => String
  field :hashtags, :type => Array
  field :links, :type => Array
  field :retweet_count, :type => Integer 
  field :in_reply_to_screen_name, :type => String
  field :favorited, :type=> Boolean
  field :followers, :type => Integer
  field :friends, :type => Integer
  field :gender, :type =>String

  attr_protected
  #attr_accessible :id, :term_id, :text, :lang, :user, :geo, :retweeted, :created_at, :updated_at
  
  belongs_to :term
  
  def self.build
    Tweet.map_reduce(map, reduce, :out => 'tweets_per_hour')
  end
  
  def self.demo
    "demo"
  end

    def map
      'function() {
        var re = /(\d{2,2}):\d{2,2}:\d{2,2}/;
        var hour = re.exec(this.created_at)[1];
   
        emit(hour, 1);
      }'
    end

    def reduce
      <<-EOS
        function(key, values) {
          var count = 0;
   
          for(i in values) {
            count += values[i]
          }
   
          return count;
        }
      EOS
    end

end
