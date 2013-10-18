# original source http://forrst.com/posts/Managing_MongoDB_Map_Reduce_Jobs_in_Rails-YGl
# put this into lib/mr/dings_per_day.rb (so it can be found automagically
# Call it with MR::DingsPerDay.new.build

module TweetsPerHour
  
  def build
    Tweet.map_reduce(map, reduce, :out => 'tweets_per_hour')
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