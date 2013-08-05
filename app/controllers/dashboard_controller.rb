class DashboardController < ApplicationController
  def index
    @tweets_per_hour = MR::TweetssPerHour.new.build
  end
end
