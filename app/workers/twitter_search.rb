require 'twitter'
require 'sexmachine'
require 'pp'

class TwitterSearch
#  include Sidekiq::Worker

  DESIRED = %w{created_at text lang id}
  def perform(term)
    # gem to calculate the gender
    sex_machine = SexMachine::Detector.new(:case_sensitive => false)

    options = {:result_type => "recent"}
    options.merge(term.last_id.nil? ? {} : {:since_id => term.last_id})
    search = Twitter.search(term.keywords, options)
    search.results.map do |status|
      data = status.attrs.select{|k,v| !v.nil? && DESIRED.include?(k.to_s)}
      data[:user] = status.user.id
      data[:term_id] = term.id
      
      # gender calculation
      data[:gender] = sex_machine.get_gender(status.user.name.split(" ").first)
        
      tweet = Tweet.new(data)
      tweet.save!
      puts tweet.inspect 
    end
    term.update_attributes({:last_id => search.max_id, :searched_at => DateTime.now})
  end

end

#a = TwitterSearch.new
#a.perform('io')
