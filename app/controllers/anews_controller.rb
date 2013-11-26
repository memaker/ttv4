class AnewsController < ApplicationController
  # GET /anews
  # GET /anews.json
  def index
    @anews = Anew.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @anews }
    end
  end

  # GET /anews/1
  # GET /anews/1.json
  def show
    @anews = Anew.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @anews }
    end
  end

  # GET /anews/new
  # GET /anews/new.json
  def new
    @anews = Anew.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @anews }
    end
  end

  # GET /anews/1/edit
  def edit
    @anews = Anew.find(params[:id])
  end

  # POST /anews
  # POST /anews.json
  def create
    @anews = Anew.new(params[:anews])

    respond_to do |format|
      if @anews.save
        format.html { redirect_to @anews, notice: 'Anew was successfully created.' }
        format.json { render json: @anews, status: :created, location: @anews }
      else
        format.html { render action: "new" }
        format.json { render json: @anews.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /anews/1
  # PUT /anews/1.json
  def update
    @anews = Anew.find(params[:id])

    respond_to do |format|
      if @anews.update_attributes(params[:anews])
        format.html { redirect_to @anews, notice: 'Anew was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @anews.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /anews/1
  # DELETE /anews/1.json
  def destroy
    @anews = Anew.find(params[:id])
    @anews.destroy

    respond_to do |format|
      format.html { redirect_to anews_url }
      format.json { head :no_content }
    end
  end
end
