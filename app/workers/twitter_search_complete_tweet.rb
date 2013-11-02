require 'twitter'

class TwitterSearch

  def initialize
    # gem to calculate the gender
    @gender_detector = SexMachine::Detector.new(:case_sensitive => false)  
  end

  def perform()
    Term.all.asc(:searched_at).each do |term|
      # set some search options
      options = {:result_type => "recent"}
      options.merge(term.last_id.nil? ? {} : {:since_id => term.last_id})
      options.merge({:lang => 'es'}) # tweets on Spanish only

      # logging some information
      Rails.logger.info "Searching for terms #{term.description} with #{search.results.size.to_s} results."
      
      # perform the search
      search = Twitter.search(term.keywords, options)
      search.results.map do |status|
        save(status, term)
      end
      
      # update the term
      term.update_attributes({:last_id => search.max_id, :searched_at => DateTime.now})
    end
  end

  def save(status, term)
    begin
        tweet = Tweet.new
        tweet = status.to_hash

        # gender calculation
        tweet.gender = @gender_detector.get_gender(status.user.name.split(" ").first)
        tweet.term = term
        tweet.save
    rescue Twitter::Error::TooManyRequests => error
      puts error.backtrace
      sleep error.rate_limit.reset_in
      retry
    rescue Twitter::Error => error
      puts  error.backtrace
    end
  end

end

