CREATE TABLE song (
    id serial PRIMARY KEY,
    title varchar
);

CREATE TABLE "user" (
    id serial PRIMARY KEY,
    username varchar
);

CREATE TABLE song_user (
    song_id integer,
    user_id integer,
    PRIMARY KEY (song_id, user_id)
);

INSERT INTO song (id, title) values (1, "title1");
INSERT INTO "user" (id, username) values (1, "username1");
INSERT INTO "user" (id, username) values (2, "username2");
INSERT INTO "user" (id, username) values (3, "username3");
INSERT INTO "user" (id, username) values (4, "username4");

INSERT INTO song_user (song_id, user_id) values (1, 1);
INSERT INTO song_user (song_id, user_id) values (1, 2);

-- vim: set sw=4 :
