class HomeController < ApplicationController
  def search
  	@tweets = Tweet.all.order("created_at DESC")
	respond_to do |format|
		format.html
		format.csv { send_data @tweets.to_csv, filename: "tweets-#{Date.today}.csv" }
	end
  end

  def keyword
  	if !params.has_key?(:keyword) || params[:keyword].blank?
	  	@tweets = Tweet.None
  	else
	  	@tweets = Tweet.joins("INNER JOIN alerts on tweets.alert_id = alerts.id").where("alerts.text LIKE ?", "%#{params[:keyword]}%").order("created_at DESC")
	end

	respond_to do |format|
		render "search" and return
		format.csv { send_data @tweets.to_csv, filename: "tweets-#{Date.today}.csv" }
	end
  end

  def user
  	if !params.has_key?(:user) || params[:user].blank?
	  	@tweets = Tweet.None
  	else
	  	@tweets = Tweet.where("user_name LIKE ?", "%#{params[:user]}%").order("created_at DESC")
	end
	respond_to do |format|
		render "search" and return
		format.csv { send_data @tweets.to_csv, filename: "tweets-#{Date.today}.csv" }
	end
  end

  def alerter
  	if !params.has_key?(:alerter) || params[:alerter].blank?
	  	@tweets = Tweet.None
  	else
	  	@tweets = Tweet.joins("INNER JOIN alerts on tweets.alert_id = alerts.id").where("alerts.user_name LIKE ?", "%#{params[:alerter]}%").order("created_at DESC")
	end
	respond_to do |format|
		render "search" and return
		format.csv { send_data @tweets.to_csv, filename: "tweets-#{Date.today}.csv" }
	end
  end

  def stat
  	@tweet_count = Tweet.all.group(:tid).count.count
  	@account_count = Tweet.all.group(:user_name).count.count
  	@alert_count = Alert.all.group(:tid).count.count
  	@alerter_count = Alert.all.group(:user_name).count.count
  end
end
