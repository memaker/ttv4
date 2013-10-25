# original source from http://yehudakatz.com/2009/11/12/better-ruby-idioms/

module TweetsPerGender
  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    # any method placed here will apply to classes
    def acts_as_something
      send :include, InstanceMethods
    end

    def chart_tweets_per_gender(data)
      @chart_tweets_per_gender = LazyHighCharts::HighChart.new('graph') do |f|
        f.title({ :text=>"Combination chart"})
        f.options[:xAxis][:categories] = ['Apples', 'Oranges', 'Pears', 'Bananas', 'Plums']
        f.labels(:items=>[:html=>"Total fruit consumption", :style=>{:left=>"40px", :top=>"8px", :color=>"black"} ])
        f.series(:type=> 'column',:name=> 'Jane',:data=> [3, 2, 1, 3, 4])
        f.series(:type=> 'column',:name=> 'John',:data=> [2, 3, 5, 7, 6])
        f.series(:type=> 'column', :name=> 'Joe',:data=> [4, 3, 3, 9, 0])
        f.series(:type=> 'column', :name=> 'Joe',:data=> [4, 3, 3, 9, 0])
        f.series(:type=> 'spline',:name=> 'Average', :data=> [3, 2.67, 3, 6.33, 3.33])
        f.series(:type=> 'pie',:name=> 'Total consumption',
        :data=> [
          {:name=> 'Jane', :y=> 13, :color=> 'red'},
          {:name=> 'John', :y=> 23,:color=> 'green'},
          {:name=> 'Joe', :y=> 19,:color=> 'blue'}
        ],
        :center=> [100, 80], :size=> 100, :showInLegend=> false)
      end
    end

    def map_tweets_per_gender
      <<-EOS
      function() {
        var re = /(\d{2,2}):\d{2,2}:\d{2,2}/;
        var hour = re.exec(this.created_at);

        emit(hour, 1);
      }
      EOS
    end

    def reduce_tweets_per_gender
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

    def self.demo_tweets_per_gender
      map = %Q{
        function() { 
          emit(this.gender, 1);
        }
      }

      reduce = %Q{
        function(key, values) {
          var count = 0;

          for(i in values) {
            count += values[i]
          }

          return count;
        }
      }

      self.map_reduce(map, reduce).out(inline: true)
    end
  end

  module InstanceMethods
  # any method placed here will apply to instaces, like @hickwall
  end
end
