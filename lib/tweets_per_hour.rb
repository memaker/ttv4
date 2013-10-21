# original source from http://yehudakatz.com/2009/11/12/better-ruby-idioms/

module TweetsPerHour
  def self.included(base)
    base.send :extend, ClassMethods
  end
  
  module ClassMethods
    # any method placed here will apply to classes
    def acts_as_something
      send :include, InstanceMethods
    end
    
    def chart_tweets_per_hour
      data = map_reduce(map_tweets_per_hour, reduce_tweets_per_hour).out(inline: 1)

      LazyHighCharts::HighChart.new('pie') do |f|
        f.chart({:defaultSeriesType=>"pie" , :margin=> [50, 200, 60, 170]} )
        series = {
          :type=> 'pie',
          :name=> 'Browser share',
          :data=> [
            ['Firefox', 45.0],
            ['IE', 26.8],
           {
              :name=> 'Chrome', 
              :y=> 12.8,
              :sliced=> true,
              :selected=> true
           },
            ['Safari', 8.5],
            ['Opera', 6.2],
            ['Others', 0.7]
          ]
        }
        f.series(series)
        f.options[:title][:text] = "THA PIE"
        f.legend(:layout=> 'vertical',:style=> {:left=> 'auto', :bottom=> 'auto',:right=> '50px',:top=> '100px'}) 
        f.plot_options(:pie=>{
          :allowPointSelect=>true, 
          :cursor=>"pointer" , 
          :dataLabels=>{
            :enabled=>true,
            :color=>"black",
            :style=>{
              :font=>"13px Trebuchet MS, Verdana, sans-serif"
            }
          }
        })
      end      
    end
   
    def map_tweets_per_hour
      'function() {
        var re = /(\d{2,2}):\d{2,2}:\d{2,2}/;
        var hour = re.exec(this.created_at)[1];
   
        emit(hour, 1);
      }'
    end

    def reduce_tweets_per_hour
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
