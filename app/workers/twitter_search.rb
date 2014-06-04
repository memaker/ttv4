require 'twitter'

class TwitterSearch
  def initialize
    # gem to calculate the gender
    @gender_detector = SexMachine::Detector.new(:case_sensitive => false)

    # classifier
    puts 'Creating the classifier for the Valence'
    @classifier_bayes_valence = Classifier::Bayes.new '1', '2', '3', '4', '5'
    Anew.all.each do |anew|
      case anew.valmnall
        when 1 .. 2
          @classifier_bayes_valence.train_1 anew.sword
        when 8 .. 9
          @classifier_bayes_valence.train_5 anew.sword
        when 2 .. 4
          @classifier_bayes_valence.train_2 anew.sword
        when 6 .. 8
          @classifier_bayes_valence.train_4 anew.sword
        when 4 .. 6
          @classifier_bayes_valence.train_3 anew.sword
        else
          # type code here
      end
    end
=begin
    puts "Creating the classifier for the Leads"
    @classifier_bayes_lead = Classifier::Bayes.new 'lead', 'nolead'
    CorpusLead.all.each do |c|
      case c.leadorno
      when 'l'
        @classifier_bayes_lead.train_lead c.tweet
      when 'n'
        @classifier_bayes_lead.train_nolead c.tweet
      end
    end
=end
    # create new classifier instance
    @nbayes = NBayes::Base.new
    # train it - notice split method used to tokenize text
    CorpusLead.all.each do |c|
      case c.leadorno
        when 'l'
          @nbayes.train(c.tweet.split(/\s+/), 'lead')
        when 'n'
          @nbayes.train(c.tweet.split(/\s+/), 'nolead')
        else
          # type code here
      end
    end

  end

  def perform
    Term.all.asc(:searched_at).each do |term|
      options = {:result_type => "recent"}
      options = options.merge(term.last_id.nil? ? {} : {:since_id => term.last_id})
      options = options.merge({lang: 'es'}) # tweets on Spanish only
      # options = options.merge({geocode: '40.416480,-3.697858,600mi'}) # tweets from Spain only
      search = Twitter.search(term.keywords, options)

      Rails.logger.info "Searching for terms #{term.description} with #{search.results.size.to_s} results."
      puts "Searching for terms #{term.description} with #{search.results.size.to_s} results."
      search.results.map do |status|
        save(status, term)
      end
      term.update_attributes({:last_id => search.max_id, :searched_at => DateTime.now})
    end
  end

  def save(status, term)
    begin
      tweet = Tweet.new
      # tweet = Tweet.new(status)

      tweet.user = status.user.to_json
      tweet.name = status.user.name
      tweet.screen_name = status.user.screen_name
      tweet.user_id = status.user.id
      tweet.lang = status.lang
      tweet.country_code = status.place.country_code if status.place
      # tweet.geo_enabled = status.user.geo_enabled
      # tweet.coordinates = status.coordinates
      # tweet.location = status.user.location
      tweet.text = status.text
      tweet.hashtags = status.hashtags.map{|hashtag| hashtag.text}
      tweet.links = status.urls.map{ |url| url.url}
      tweet.retweet_count = status.retweet_count
      tweet.in_reply_to_screen_name = status.in_reply_to_screen_name
      tweet.favorited = status.favorited
      tweet.followers = status.user.followers_count
      tweet.friends = status.user.friends_count
      tweet.tweeted_at = status.created_at

      # gender calculation
      tweet.gender = @gender_detector.get_gender(status.user.name.split(' ').first)

      # valence calculation
      tweet.valence = @classifier_bayes_valence.classify status.text

      # tweet.lead = @classifier_bayes_lead.classify status.text
      result = @nbayes.classify(status.text.split(/\s+/))
      tweet.lead_data = result
      tweet.lead = result.max_class # lead - nolead

      # associated term
      tweet.term = term
      tweet.save
    rescue Twitter::Error::TooManyRequests => error
      puts error.backtrace
      sleep error.rate_limit.reset_in
      retry
    rescue Twitter::Error => error
      puts error.backtrace
    end
  end

end