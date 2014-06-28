class SongUser < ActiveRecord::Base
	has_paper_trail
  attr_accessible :song_id, :user_id

	belongs_to :song
	belongs_to :user
end
