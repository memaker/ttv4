class CorpusLeadsController < ApplicationController
  # GET /corpus_leads
  # GET /corpus_leads.json
  def index
    @corpus_leads = CorpusLead.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @corpus_leads }
    end
  end

  # GET /corpus_leads/1
  # GET /corpus_leads/1.json
  def show
    @corpus_lead = CorpusLead.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @corpus_lead }
    end
  end

  # GET /corpus_leads/new
  # GET /corpus_leads/new.json
  def new
    @corpus_lead = CorpusLead.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @corpus_lead }
    end
  end

  # GET /corpus_leads/1/edit
  def edit
    @corpus_lead = CorpusLead.find(params[:id])
  end

  # POST /corpus_leads
  # POST /corpus_leads.json
  def create
    @corpus_lead = CorpusLead.new(params[:corpus_lead])

    respond_to do |format|
      if @corpus_lead.save
        format.html { redirect_to @corpus_lead, notice: 'Corpus lead was successfully created.' }
        format.json { render json: @corpus_lead, status: :created, location: @corpus_lead }
      else
        format.html { render action: "new" }
        format.json { render json: @corpus_lead.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /corpus_leads/1
  # PUT /corpus_leads/1.json
  def update
    @corpus_lead = CorpusLead.find(params[:id])

    respond_to do |format|
      if @corpus_lead.update_attributes(params[:corpus_lead])
        format.html { redirect_to @corpus_lead, notice: 'Corpus lead was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @corpus_lead.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /corpus_leads/1
  # DELETE /corpus_leads/1.json
  def destroy
    @corpus_lead = CorpusLead.find(params[:id])
    @corpus_lead.destroy

    respond_to do |format|
      format.html { redirect_to corpus_leads_url }
      format.json { head :no_content }
    end
  end
end
