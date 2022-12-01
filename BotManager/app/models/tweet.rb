class Tweet < ApplicationRecord
	def self.to_csv
		attributes = %w{tid link user_name text archive_link pharos_id}

		CSV.generate(headers: true) do |csv|
			csv << attributes

			all.each do |user|
				csv << attributes.map{ |attr| user.send(attr) }
			end
		end
	end
end
