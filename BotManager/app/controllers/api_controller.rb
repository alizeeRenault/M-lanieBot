class ApiController < ApplicationController
	protect_from_forgery except: :post_tweet

	def post_tweet
		begin
			Bot.add_one_tweet_from_api params[:tid],  (params[:keys].to_s)
		rescue
			head 500 and return
		end
		head 200 and return
	end
end