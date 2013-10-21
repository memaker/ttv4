# original source from http://yehudakatz.com/2009/11/12/better-ruby-idioms/

module TweetsPerLocation
  def self.included(base)
    base.send :extend, ClassMethods
  end
  
  module ClassMethods
    # any method placed here will apply to classes
    def acts_as_something
      send :include, InstanceMethods
    end
    
    def chart_tweets_per_location
      data = map_reduce(map_tweets_per_location, reduce_tweets_per_location).out(inline: 1)
      
      LazyHighCharts::HighChart.new('column') do |f|
        f.series(:name=>'John',:data=> [3, 20, 3, 5, 4, 10, 12 ])
        f.series(:name=>'Jane',:data=>[1, 3, 4, 3, 3, 5, 4,-46] ) 
        f.title({ :text=>"example test title from controller"})
      
        ### Options for Bar
        ### f.options[:chart][:defaultSeriesType] = "bar"
        ### f.plot_options({:series=>{:stacking=>"normal"}})
      
        ## or options for column
        f.options[:chart][:defaultSeriesType] = "column"
        f.plot_options({:column=>{:stacking=>"percent"}})
      end
    end
 
    def map_tweets_per_location
      'function() {
        var re = /(\d{2,2}):\d{2,2}:\d{2,2}/;
        var hour = re.exec(this.created_at)[1];
   
        emit(hour, 1);
      }'
    end

    def reduce_tweets_per_location
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
 
  module InstanceMethods
    # any method placed here will apply to instaces, like @hickwall
  end
end
