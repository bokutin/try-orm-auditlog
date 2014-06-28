#!/usr/bin/env ruby

system("rm song.db")
system("sqlite3 song.db < ../share/schema.sql")

require 'rubygems'
require 'active_record'
ActiveRecord::Base.establish_connection(
	:adapter  => 'sqlite3',
	:database => 'song.db',
)

class User < ActiveRecord::Base
  self.table_name = 'user'
	has_many :song_users
	has_many :favorite_songs, through: :song_users, source: :song
end

class Song < ActiveRecord::Base
  self.table_name = 'song'
	has_many :song_users
	has_many :fans, through: :song_users, source: :user
end

class SongUser < ActiveRecord::Base
  self.table_name = 'song_user'
	belongs_to :song
	belongs_to :user
end

User.all.each{ |u|
	p u.username
	u.favorite_songs.each{ |s|
		p s.title
	}
}
