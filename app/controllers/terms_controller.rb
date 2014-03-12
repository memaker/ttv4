class TermsController < ApplicationController
  # GET /terms
  # GET /terms.json
  def index
    # @terms = Term.all
    @user = current_user
    @terms = @user.terms

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @terms }
    end
  end

  # GET /terms/1
  # GET /terms/1.json
  def show
    @term = Term.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @term }
    end
  end

  # GET /terms/new
  # GET /terms/new.json
  def new
    @term = Term.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @term }
    end
  end

  # GET /terms/1/edit
  def edit
    @term = Term.find(params[:id])
  end

  # POST /terms
  # POST /terms.json
  def create
    @term = Term.new(params[:term])
    @term.user = current_user

    respond_to do |format|
      if @term.save
        format.html { redirect_to @term, notice: 'Term was successfully created.' }
        format.json { render json: @term, status: :created, location: @term }
      else
        format.html { render action: "new" }
        format.json { render json: @term.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /terms/1
  # PUT /terms/1.json
  def update
    @term = Term.find(params[:id])

    respond_to do |format|
      if @term.update_attributes(params[:term])
        format.html { redirect_to @term, notice: 'Term was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @term.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /terms/1
  # DELETE /terms/1.json
  def destroy
    @term = Term.find(params[:id])

    ## it also deletes the associated tweets
    @tweets = @term.tweets
    @tweets.destroy_all

    @term.destroy

    respond_to do |format|
      format.html { redirect_to terms_url }
      format.json { head :no_content }
    end
  end

  # GET /terms/1/showgender
  def showgender
    @term = Term.find(params[:id])
    @from = params[:from]
    if (@from.nil?)
      @from = "01-01-2013"
    end

    @to = params[:to]
    if (@to.nil?)
      @to = "31-12-2013"
    end

    # tweets per gender: map reduce and chart generation
    @tweets = Tweet.where(:term_id => @term, :tweeted_at.gte => @from, :tweeted_at.lte => @to).map_reduce(Tweet.map_tweets_per_gender, Tweet.reduce_tweets_per_gender).out(inline: true)
    @chart_data = Array.new
    @tweets.each do |pair|
      @chart_data.push(pair.values.to_a)
    end
    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.chart({:defaultSeriesType=>"pie" , :margin=> [50, 200, 60, 170]} )
        series = {
          :type=> 'pie',
          :name=> 'Browser share',
          :data=> @chart_data
        }
        f.series(series)
        f.options[:title][:text] = "Tweets per gender"
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

  # GET /terms/1/showdatetime
  def showdatetime

    @term = Term.find(params[:id])
    scope = {"term_id" => @term}

    if params.has_key?("post")
      if params["post"].has_key?("location")
        scope = {"location" => params["post"]["location"]}
      end

      if params["post"].has_key?("gender")
        scope = {"gender" => params[:post][:gender]}
      end
    end

    if params.has_key?(:from)
      @from = params[:from]
      if (@from.nil?)
        @from = "01-01-2013"
      end
      scope = {:tweeted_at.gte => @from}
    end

    if params.has_key?(:to)
      @to = params[:to]
      if (@to.nil?)
        @to = "31-12-2013"
      end
      scope = {:tweeted_at.lte => @to}
    end

    # tweets per time map reduce and chart generation
    @tweets = Tweet.where(scope).map_reduce(Tweet.map_tweets_per_time, Tweet.reduce_tweets_per_time).out(inline: true)
    @chart_data = Array.new
    @tweets.each do |pair|
      @chart_data.push(pair.values.to_a)
    end
    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.chart({:defaultSeriesType=>"spline"})
      series = {
        :type=> 'spline',
        :name=> 'Tweets per time',
        :data=> @chart_data
      }
      f.series(series)
      f.options[:title][:text] = "Tweets timeline"
      f.options[:subtitle][:text] = "The number of tweets is grouped by hour"
      f.options[:xAxis] = {
        :title => { :text => "Date and time" },
        :type => 'datetime',
        :dateTimeLabelFormats => { day: "%b %e"}
        }
      f.options[:yAxis] = {
        :title => { :text => "Number of tweets" },
        :min => 0
      }
    end
  end

  # GET /terms/1/showlocation
  def showlocation
    @from = params[:from]
    if (@from.nil?)
      @from = "01-01-2013"
    end

    @to = params[:to]
    if (@to.nil?)
      @to = "31-12-2013"
    end

    # tweets per location map reduce and chart generation
    @map = {
      :center => {:latlng => [41.385116, 2.173423], :zoom => 12},
      :markers => [{:latlng => [41.385116, 2.173423],
                    :popup => "Hello!"
                  }]
     }

  end

  # GET /terms/1/showlist
  def showlist
    @term = Term.find(params[:id])
    scope = {"term_id" => @term}

    if params.has_key?("post")
      if params["post"].has_key?("location") && !params["post"]["location"].nil?
        scope["location"] = params["post"]["location"]
      end

      if params["post"].has_key?("gender")
        scope["gender"] = params["post"]["gender"]
      end
    end

    if params.has_key?("from")
      @from = params["from"]
      if (@from.nil?)
        @from = "01-01-2013"
      end
      scope["tweeted_at.gte"] = @from
    end

    if params.has_key?("to")
      @to = params["to"]
      if (@to.nil?)
        @to = "31-12-2013"
      end
      scope["tweeted_at.lte"] = @to
    end

    # tweets per time map reduce and chart generation
    @tweets = Tweet.where(scope)
  end

  # GET /terms/1/showlead
  def showlead
    @term = Term.find(params[:id])
    @from = params[:from]
    if (@from.nil?)
      @from = "01-01-2013"
    end

    @to = params[:to]
    if (@to.nil?)
      @to = "31-12-2013"
    end

    @users = Tweet.where(:term_id => @term, :tweeted_at.gte => @from, :tweeted_at.lte => @to, :lead => "lead")
      .map_reduce(Tweet.map_users_per_lead, Tweet.reduce_users_per_lead)
      .out(inline: true)
  end
  
  # GET /terms/1/showlead
  def showuserlist
    @term = Term.find(params[:id])
   
    # this is the user selected on the screen
    @user = {'user_id' => params[:user_id], 'name' => params[:name]}
    # these are the tweets: 1.- from the term 2.- from the user 3.- with positive lead
    @tweets = Tweet.where(:term_id => @term, :user_id => @user_id, :lead => "lead")
    debugger

  end


  # GET /terms/1/dashboard
  # GET /terms.json
  def dashboard
    @term = Term.find(params[:id])
    @tweets = @term.tweets

    respond_to do |format|
      format.html # dashboard.html.erb
      format.json { render json: @terms }
    end
  end



end

