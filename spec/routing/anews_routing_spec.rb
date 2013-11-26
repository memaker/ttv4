require "spec_helper"

describe AnewsController do
  describe "routing" do

    it "routes to #index" do
      get("/anews").should route_to("anews#index")
    end

    it "routes to #new" do
      get("/anews/new").should route_to("anews#new")
    end

    it "routes to #show" do
      get("/anews/1").should route_to("anews#show", :id => "1")
    end

    it "routes to #edit" do
      get("/anews/1/edit").should route_to("anews#edit", :id => "1")
    end

    it "routes to #create" do
      post("/anews").should route_to("anews#create")
    end

    it "routes to #update" do
      put("/anews/1").should route_to("anews#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/anews/1").should route_to("anews#destroy", :id => "1")
    end

  end
end
