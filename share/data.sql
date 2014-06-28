INSERT INTO songs (id, title, created_at, updated_at) values (1, "title1", CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO users (id, username, created_at, updated_at) values (1, "username1", CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO users (id, username, created_at, updated_at) values (2, "username2", CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO users (id, username, created_at, updated_at) values (3, "username3", CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO users (id, username, created_at, updated_at) values (4, "username4", CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO song_users (song_id, user_id, created_at, updated_at) values (1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO song_users (song_id, user_id, created_at, updated_at) values (1, 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- vim: set sw=4 :
