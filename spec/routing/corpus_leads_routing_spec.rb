require "spec_helper"

describe CorpusLeadsController do
  describe "routing" do

    it "routes to #index" do
      get("/corpus_leads").should route_to("corpus_leads#index")
    end

    it "routes to #new" do
      get("/corpus_leads/new").should route_to("corpus_leads#new")
    end

    it "routes to #show" do
      get("/corpus_leads/1").should route_to("corpus_leads#show", :id => "1")
    end

    it "routes to #edit" do
      get("/corpus_leads/1/edit").should route_to("corpus_leads#edit", :id => "1")
    end

    it "routes to #create" do
      post("/corpus_leads").should route_to("corpus_leads#create")
    end

    it "routes to #update" do
      put("/corpus_leads/1").should route_to("corpus_leads#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/corpus_leads/1").should route_to("corpus_leads#destroy", :id => "1")
    end

  end
end
