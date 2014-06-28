#!/usr/bin/env ruby

system("rm db/development.sqlite3")
system("rake db:migrate")
system("sqlite3 db/development.sqlite3 < ../share/data.sql")

def showing
	Song.all.each{ |s|
		puts "Song: " + s.title
		s.fans.each{ |u|
			puts "    User: " + u.username
		}
	}
end

puts "--> showing"
showing
puts ""

puts "--> modify"
ActiveRecord::Base.transaction do
	s = Song.first
	s.title = "title1b"
	s.fans = User.where(:username => ["username1", "username3", "username4"])
	s.save
end
puts ""

puts "--> showing"
showing
puts ""

__END__



% rails runner script/try_audit.rb
==  CreateSongs: migrating ====================================================
-- create_table(:songs)
   -> 0.0013s
==  CreateSongs: migrated (0.0013s) ===========================================

==  CreateUsers: migrating ====================================================
-- create_table(:users)
   -> 0.0010s
==  CreateUsers: migrated (0.0010s) ===========================================

==  CreateSongUsers: migrating ================================================
-- create_table(:song_users)
   -> 0.0014s
==  CreateSongUsers: migrated (0.0015s) =======================================

==  CreateActivities: migrating ===============================================
-- create_table(:activities)
   -> 0.0011s
-- add_index(:activities, [:trackable_id, :trackable_type])
   -> 0.0003s
-- add_index(:activities, [:owner_id, :owner_type])
   -> 0.0003s
-- add_index(:activities, [:recipient_id, :recipient_type])
   -> 0.0004s
==  CreateActivities: migrated (0.0024s) ======================================

--> showing
Song: title1
    User: username1
    User: username2

--> modify

--> showing
Song: title1b
    User: username1
    User: username3
    User: username4



% sqlite3 db/development.sqlite3 '.tables'
activities         song_users         users
schema_migrations  songs



% sqlite3 -header -column db/development.sqlite3 'select * from activities;'
id          trackable_id  trackable_type  owner_id    owner_type  key                parameters  recipient_id  recipient_type  created_at                  updated_at
----------  ------------  --------------  ----------  ----------  -----------------  ----------  ------------  --------------  --------------------------  --------------------------
1           2             SongUser                                song_user.destroy  --- {}
                                   2014-06-27 21:33:06.346448  2014-06-27 21:33:06.346448
2           3             SongUser                                song_user.create   --- {}
                                   2014-06-27 21:33:06.357211  2014-06-27 21:33:06.357211
3           4             SongUser                                song_user.create   --- {}
                                   2014-06-27 21:33:06.359821  2014-06-27 21:33:06.359821
4           1             Song                                    song.update        --- {}
                                   2014-06-27 21:33:06.363539  2014-06-27 21:33:06.363539
