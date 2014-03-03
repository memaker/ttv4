class DashboardController < ApplicationController
  def index

    # this is for the tweets
    @tweets = "hola"

    # tweets per location map reduce and chart generation
    @map = {
        :center => {:latlng => [41.385116, 2.173423], :zoom => 12},
        :markers => [{:latlng => [41.385116, 2.173423],
                      :popup => "Hello!"
                     }]
    }

  end
end
