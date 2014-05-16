module Api
	module V2
		class LeadsController < ApplicationController # Api::BaseController
      respond_to :json

      def index
        @term = Term.find(params[:id])

        @leads = Tweet.where(:term_id => @term, :lead => 'lead')
          .map_reduce(Tweet.map_users_per_lead, Tweet.reduce_users_per_lead)
          .out(inline: true)
        @leads_json = Array.new

        @leads.each do |lead|
          @tweets = Tweet.where(:screen_name => lead['_id']['name'], :lead => 'lead')
          texts = Array.new
          @tweets.each do |tweet|
            texts.push({'text' => tweet.text})
          end

          # add text to the response
          #lead.to_json(:include => { :tweets => texts.to_json })
          @leads_json.push lead.merge('tweets' => texts)
        end

        respond_with @leads_json
      end

		end
	end
end
