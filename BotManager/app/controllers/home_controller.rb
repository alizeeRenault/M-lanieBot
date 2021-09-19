class HomeController < ApplicationController
  def search
  	@tweets = Tweet.all
  end
end
