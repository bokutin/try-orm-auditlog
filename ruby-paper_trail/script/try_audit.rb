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
   -> 0.0016s
==  CreateSongs: migrated (0.0017s) ===========================================

==  CreateUsers: migrating ====================================================
-- create_table(:users)
   -> 0.0010s
==  CreateUsers: migrated (0.0011s) ===========================================

==  CreateSongUsers: migrating ================================================
-- create_table(:song_users)
   -> 0.0008s
==  CreateSongUsers: migrated (0.0009s) =======================================

==  CreateVersions: migrating =================================================
-- create_table(:versions)
   -> 0.0010s
-- add_index(:versions, [:item_type, :item_id])
   -> 0.0003s
==  CreateVersions: migrated (0.0014s) ========================================

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



foil bokutin % sqlite3 db/development.sqlite3 '.tables'
schema_migrations  songs              versions
song_users         users



config/initializers/active_record_patch.rb 無し
% sqlite3 -header -column db/development.sqlite3 'select * from versions;'
id          item_type   item_id     event       whodunnit   object      created_at
----------  ----------  ----------  ----------  ----------  ----------  --------------------------
1           SongUser    3           create                              2014-06-27 21:15:11.485471
2           SongUser    4           create                              2014-06-27 21:15:11.488572
3           Song        1           update                  ---
title:  2014-06-27 21:15:11.493773



config/initializers/active_record_patch.rb 有り
% sqlite3 -header -column db/development.sqlite3 'select * from versions;'
id          item_type   item_id     event       whodunnit   object                                                                                                                    created_at                
----------  ----------  ----------  ----------  ----------  ---------------------------------------------------------------------------------------------                             --------------------------
1           SongUser    2           destroy                 ---
song_id: 1
user_id: 2
created_at: 2014-06-27 21:21:22.000000000 Z
updated_at: 2014-06-27 21:21:22.000000000 Z
id: 2
  2014-06-27 21:21:22.550718
2           SongUser    3           create                                                                                                                                            2014-06-27 21:21:22.558769
3           SongUser    4           create                                                                                                                                            2014-06-27 21:21:22.560535
4           Song        1           update                  ---
title: title1
created_at: 2014-06-27 21:21:22.000000000 Z
updated_at: 2014-06-27 21:21:22.000000000 Z
id: 1
          2014-06-27 21:21:22.564627
