require 'twitter'
#require 'awesome_print'

class TwitterSearch
  #include Sidekiq::Worker

  def initialize
    # gem to calculate the gender
    @gender_detector = SexMachine::Detector.new(:case_sensitive => false)  
    @search_interval = 30 
  end

  def perform()
    Term.all.asc(:searched_at).each do |term|
      options = {:result_type => "recent"}
      #ptions = {}
      options.merge(term.last_id.nil? ? {} : {:since_id => term.last_id})
      search = Twitter.search(term.keywords, options)

      Rails.logger.info "Searching for terms #{term.description} with #{search.results.size.to_s} results."
      search.results.map do |status|
        save(status, term)
      end
      term.update_attributes({:last_id => search.max_id, :searched_at => DateTime.now})
    end
  end

  def save(status, term)
    begin
      tweet = Tweet.new
      tweet.name = status.user.name
      tweet.username = status.user.name
      tweet.user_id = status.user.id
      tweet.lang = status.lang
      tweet.country_code = status.place.country_code if status.place
      #  tweet.geo_enabled = status.user.geo_enabled
      #  tweet.coordinates = status.geo.coordinates unless tweet.geo.nil?
      tweet.location = status.user.location
      tweet.text = status.text
      tweet.hashtags = status.hashtags.map{|hashtag| hashtag.text}
      tweet.links = status.urls.map{ |url| url.url}
      tweet.retweet_count = status.retweet_count
      tweet.in_reply_to_screen_name = status.in_reply_to_screen_name
      tweet.favorited = status.favorited 
      tweet.followers = status.user.followers_count
      tweet.friends = status.user.friends_count

      # gender calculation
      tweet.gender = @gender_detector.get_gender(status.user.name.split(" ").first)
      tweet.tweeted_at = status.created_at
      tweet.term = term
      tweet.save
    rescue Twitter::Error::TooManyRequests => error
      puts error.backtrace
      sleep error.rate_limit.reset_in
      retry
    rescue Twitter::Error => error
      puts  error.backtrace

    else
      
    end
  end

end

