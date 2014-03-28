module Api
	module V1
		class LeadsController < ApplicationController # Api::BaseController
      respond_to :json

      def index
        @term = Term.find(params[:id])

        respond_with Tweet.where(:term_id => @term, :lead => 'lead')
          .map_reduce(Tweet.map_users_per_lead, Tweet.reduce_users_per_lead)
          .out(inline: true)
      end

		end
	end
end
