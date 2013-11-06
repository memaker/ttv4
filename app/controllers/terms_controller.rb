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
    @tweets = @term.tweets
    
    # tweets per gender: map reduce and chart generation
    @tweets_per_gender = Tweet.where(:term_id => @term).map_reduce(Tweet.map_tweets_per_gender, Tweet.reduce_tweets_per_gender).out(inline: true)
    @chart_data = Array.new
    @tweets_per_gender.each do |pair|
      @chart_data.push(pair.values.to_a)
    end
    @tweets_per_gender_chart = LazyHighCharts::HighChart.new('graph') do |f|
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

    # tweets per time map reduce and chart generation
    @tweets_per_time = Tweet.where(:term_id => @term).map_reduce(Tweet.map_tweets_per_time, Tweet.reduce_tweets_per_time).out(inline: true)
    @chart_data = Array.new
    @tweets_per_time.each do |pair|
      @chart_data.push(pair.values.to_a)
    end
    @tweets_per_time_chart = LazyHighCharts::HighChart.new('graph') do |f|
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
    
    # tweets per location map reduce and chart generation
    @mymap = {
      :center => {:latlng => [41.385116, 2.173423], :zoom => 12},
      :markers => [{:latlng => [41.385116, 2.173423],
                    :popup => "Hello!"
                  }]
     }
      
    
   
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

  def draw
    respond_to do |format|
      format.html # draw.html.erb
      format.json { render json: @term }
    end
  end
  
end

