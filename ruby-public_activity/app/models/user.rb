class User < ActiveRecord::Base
  include PublicActivity::Model
  tracked
  attr_accessible :username

	has_many :song_users
	has_many :favorite_songs, through: :song_users, source: :song
end
