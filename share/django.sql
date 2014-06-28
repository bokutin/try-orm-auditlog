INSERT INTO myapps_song (id, title) values (1, "title1");
INSERT INTO myapps_user (id, username) values (1, "username1");
INSERT INTO myapps_user (id, username) values (2, "username2");
INSERT INTO myapps_user (id, username) values (3, "username3");
INSERT INTO myapps_user (id, username) values (4, "username4");

INSERT INTO myapps_songuser (song_id, user_id) values (1, 1);
INSERT INTO myapps_songuser (song_id, user_id) values (1, 2);

-- vim: set sw=4 :
