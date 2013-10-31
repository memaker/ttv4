# original source http://forrst.com/posts/Managing_MongoDB_Map_Reduce_Jobs_in_Rails-YGl
# put this into lib/mr/dings_per_day.rb (so it can be found automagically
# Call it with MR::DingsPerDay.new.build

module MR
  class TweetsPerGender

    def build
      Tweet.collection.map_reduce(map, reduce).out(inline: true)
    end

    def map
      <<-EOS
      function() {
        emit(this.gender, 1);
      }
      EOS
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
end