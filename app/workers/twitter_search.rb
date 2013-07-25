require 'twitter'
require 'pp'

class TwitterSearch
#  include Sidekiq::Worker

  DESIRED = %w{created_at text lang id}
  def perform(term)
    options = {:result_type => "recent"}
    options.merge(term.last_id.nil? ? {} : {:since_id => term.last_id})
    search = Twitter.search(term.keywords, options)
    search.results.map do |status|
      data = status.attrs.select{|k,v| !v.nil? && DESIRED.include?(k.to_s)}
      data[:user] = status.user.id
      data[:term_id] = term.id
      tweet = Tweet.new(data)
      tweet.save!
      puts tweet.inspect 
    end
    term.update_attributes({:last_id => search.max_id, :searched_at => DateTime.now})
  end

end

#a = TwitterSearch.new
#a.perform('io')
