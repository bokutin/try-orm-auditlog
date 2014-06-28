class Song < ActiveRecord::Base
  include PublicActivity::Model
  tracked
  attr_accessible :title

	has_many :song_users
	has_many :fans, through: :song_users, source: :user
end
