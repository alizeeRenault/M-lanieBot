class Bot < ApplicationRecord
	require 'uri'
	require 'net/http'

	def self.search_words words
		CLIENT.search(words, since_id: (Alert.last.try(:id) || 1439344091934900224), include_entities: false)
	end

	def self.historic words
		CLIENT.search(words)
	end

	def self.find_by_id id
		CLIENT.status(id)
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
			if t.in_reply_to_status_id
				Alert.create(tid: t.id, link: t.url.to_s, user_name: t.user.screen_name, text: t.text)
				original_tweets << Bot.find_by_id(t.in_reply_to_status_id)
			end
		end
		original_tweets.each do |ot|
			Bot.archive ot.url.to_s
			Tweet.create(tid: ot.id, link: ot.url.to_s, user_name: ot.user.screen_name, text: ot.text, archive_link: "https://web.archive.org/web/*/" + ot.url.to_s)
		end
	end
end
