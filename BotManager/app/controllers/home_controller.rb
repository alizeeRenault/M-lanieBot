class HomeController < ApplicationController
  def search
  	@tweets = Tweet.all
  end

  def keyword
  	if !params.has_key?(:keyword) || params[:keyword].blank?
	  	@tweets = Tweet.None
  	else
	  	@tweets = Tweet.joins("INNER JOIN alerts on tweets.alert_id = alerts.id").where("alerts.text LIKE ?", "%#{params[:keyword]}%")
	end
	render "search" and return
  end

  def user
  	if !params.has_key?(:user) || params[:user].blank?
	  	@tweets = Tweet.None
  	else
	  	@tweets = Tweet.where("user_name LIKE ?", "%#{params[:user]}%")
	end
	render "search" and return
  end

  def alerter
  	if !params.has_key?(:alerter) || params[:alerter].blank?
	  	@tweets = Tweet.None
  	else
	  	@tweets = Tweet.joins("INNER JOIN alerts on tweets.alert_id = alerts.id").where("alerts.user_name LIKE ?", "%#{params[:alerter]}%")
	end
	render "search" and return
  end
end
