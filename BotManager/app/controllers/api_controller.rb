class ApiController < ApplicationController
	protect_from_forgery except: :post_tweet

	def post_tweet
		begin
			Bot.add_one_tweet params[:tid]
		rescue
			render status: 500 and return
		end
		render status: 200 and return
	end
end