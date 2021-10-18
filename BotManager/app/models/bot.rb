class Bot < ApplicationRecord
	require 'uri'
	require 'net/http'

	def self.search_words words
		CLIENT.search(words, since_id: (Alert.last.try(:tid) || 1439344091934900224), include_entities: false)
	end

	def self.historic words
		CLIENT.search(words)
	end

	def self.find_by_id id
		CLIENT.status(id) rescue nil
	end

	def self.sanitize_search_result search
		arr = []
		search.each do |t|
			arr << t
		end
		arr
	end

	def self.archive link
		uri = URI("https://web.archive.org/save")
		res = Net::HTTP.post_form(uri, 'url' => link)
	end

	def self.watch_YOU_SHALL_NOT_PASS
		search = Bot.search_words "#VousNePasserezPas"
		tweets = sanitize_search_result search
		original_tweets = []
		tweets.each do |t|
			if t.try(:in_reply_to_status_id)
				a = Alert.create(tid: t.id, link: t.url.to_s, user_name: t.user.screen_name, text: t.text)
				original_tweets << [Bot.find_by_id(t.in_reply_to_status_id), a.id]
			end
		end
		original_tweets.each do |ot|
			if !ot.nil? && Tweet.where(tid: ot[0].id).count == 0
				Bot.archive ot[0].url.to_s
				Tweet.create(tid: ot[0].id, link: ot[0].url.to_s, user_name: ot[0].user.screen_name, text: ot[0].text, archive_link: "https://web.archive.org/web/*/" + ot[0].url.to_s, alert_id: ot[1])
			end
		end
	end

	def self.historic_YOU_SHALL_NOT_PASS
		search = CLIENT.search("#VousNePasserezPas", since_id: 439344091934900224, include_entities: false)
		tweets = sanitize_search_result search
		original_tweets = []
		tweets.each do |t|
			if Alert.where(tid: t.id).count == 0
				a = Alert.create(tid: t.id, link: t.url.to_s, user_name: t.user.screen_name, text: t.text)
				begin
					original_tweets << [Bot.find_by_id(t.in_reply_to_status_id), a.id]
				rescue
				end
			end
		end
		original_tweets.each do |ot|
			if !ot.nil? && Tweet.where(tid: ot[0].id).count == 0
				Bot.archive ot[0].url.to_s
				Tweet.create(tid: ot[0].id, link: ot[0].url.to_s, user_name: ot[0].user.screen_name, text: ot[0].text, archive_link: "https://web.archive.org/web/*/" + ot[0].url.to_s, alert_id: ot[1])
			end
		end
	end
	def self.re_import_from_alert
		original_tweets = []
		Alert.all.each do |a|
			begin
				t = Bot.find_by_id(a.tid)
				original_tweets << [Bot.find_by_id(t.in_reply_to_status_id), a.id]
			rescue
			end
		end
		original_tweets.each do |ot|
			if !ot.nil? && Tweet.where(tid: ot[0].id).count == 0
				Bot.archive ot[0].url.to_s
				Tweet.create(tid: ot[0].id, link: ot[0].url.to_s, user_name: ot[0].user.screen_name, text: ot[0].text, archive_link: "https://web.archive.org/web/*/" + ot[0].url.to_s, alert_id: ot[1])
			end
		end
	end

	def self.add_tweet_from_alert_id alert_id
		alert = Bot.find_by_id(alert_id) rescue nil
		return nil if !alert
		tweet = Bot.find_by_id(alert.in_reply_to_status_id) rescue nil
		return nil if !tweet
		if Tweet.where(tid: tweet.id).count == 0
			Bot.archive tweet.url.to_s
			Tweet.create(tid: tweet.id, link: tweet.url.to_s, user_name: tweet.user.screen_name, text: tweet.text, archive_link: "https://web.archive.org/web/*/" + tweet.url.to_s, alert_id: alert_id)
		end
	end

	# def self.terrorisme_stochastique
	# 	search = CLIENT.search("terrorisme stochastique", since_id: 439344091934900224, include_entities: false)
	# 	tweets = sanitize_search_result search
	# 	original_tweets = []
	# 	tweets.each do |t|
	# 		if Alert.where(tid: t.id).count == 0
	# 			a = Alert.create(tid: t.id, link: t.url.to_s, user_name: t.user.screen_name, text: t.text)
	# 			begin
	# 				original_tweets << [Bot.find_by_id(t.in_reply_to_status_id), a.id]
	# 			rescue
	# 			end
	# 		end
	# 	end
	# 	original_tweets.each do |ot|
	# 		if !ot.nil? && Tweet.where(tid: ot[0].id).count == 0
	# 			Bot.archive ot[0].url.to_s
	# 			Tweet.create(tid: ot[0].id, link: ot[0].url.to_s, user_name: ot[0].user.screen_name, text: ot[0].text, archive_link: "https://web.archive.org/web/*/" + ot[0].url.to_s, alert_id: ot[1])
	# 		end
	# 	end
	# end

	def self.remove_duplicated_entry
		ids = Tweet.group(:tid).pluck('MIN(id)')
		Tweet.where.not(id: ids).destroy_all
		idsa = Alert.joins("INNER JOIN tweets on tweets.alert_id = alerts.id").ids
		Alert.where.not(id: idsa).destroy_all
	end


	def self.add_one_tweet id
		t = Bot.find_by_id "1450033963234365440"
		a = Alert.create(tid: t.id, link: t.url.to_s, user_name: t.user.screen_name, text: t.text)
		res = Bot.find_by_id id
		if Tweet.where(tid: id).count == 0
			Bot.archive res.url.to_s
			Tweet.create(tid: res.id, link: res.url.to_s, user_name: res.user.screen_name, text: res.text, archive_link: "https://web.archive.org/web/*/" + res.url.to_s, alert_id: a.id)
		end
	end
end
