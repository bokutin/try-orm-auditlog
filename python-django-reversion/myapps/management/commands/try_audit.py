from django.core.management.base import BaseCommand, CommandError
from myapps.models import User, Song, SongUser
import os
from django.db import transaction
from django.db.models import Q
import reversion

class Command(BaseCommand):
    help = 'Does some magical work'

    def showing(self):
        for s in Song.objects.all():
            print "--> showing"
            print s.title
            for u in s.fans.all():
                print "    " + u.username

    def handle(self, *args, **options):
        """ Do your work here """
        #self.stdout.write('There are {} things!'.format(User.objects.count()))

        os.system("rm db.sqlite3")
        os.system("python manage.py syncdb")
        os.system("sqlite3 db.sqlite3 < ../share/django.sql")
        print ""

        self.showing()
        print ""

        print "--> modify"
        with transaction.atomic(), reversion.create_revision():
            s = Song.objects.first()
            s.title = "title1b"
            s.save()

            # http://stackoverflow.com/questions/8095813/attributeerror-manyrelatedmanager-object-has-no-attribute-add-i-do-like-in
            #
            # https://docs.djangoproject.com/en/dev/topics/db/models/#extra-fields-on-many-to-many-relationships
            # Unlike normal many-to-many fields, you can't use add, create, or assignment (i.e., beatles.members = [...]) to create relationships:
            fans = User.objects.filter( Q(username="username3") | Q(username="username4") )
            #s.fans.add(fans[0])

            SongUser.objects.get(user_id=2,song_id=1).delete()
            for f in fans:
                SongUser(song=s, user=f).save()

            #s2 = Song.objects.create(title="title2")
            #s2.delete()

        print ""

        self.showing()
        print ""

"""
% sqlite3 db.sqlite3 '.schema'
CREATE TABLE "auth_permission" (
    "id" integer NOT NULL PRIMARY KEY,
    "name" varchar(50) NOT NULL,
    "content_type_id" integer NOT NULL,
    "codename" varchar(100) NOT NULL,
    UNIQUE ("content_type_id", "codename")
);
CREATE TABLE "auth_group_permissions" (
    "id" integer NOT NULL PRIMARY KEY,
    "group_id" integer NOT NULL,
    "permission_id" integer NOT NULL REFERENCES "auth_permission" ("id"),
    UNIQUE ("group_id", "permission_id")
);
CREATE TABLE "auth_group" (
    "id" integer NOT NULL PRIMARY KEY,
    "name" varchar(80) NOT NULL UNIQUE
);
CREATE TABLE "auth_user_groups" (
    "id" integer NOT NULL PRIMARY KEY,
    "user_id" integer NOT NULL,
    "group_id" integer NOT NULL REFERENCES "auth_group" ("id"),
    UNIQUE ("user_id", "group_id")
);
CREATE TABLE "auth_user_user_permissions" (
    "id" integer NOT NULL PRIMARY KEY,
    "user_id" integer NOT NULL,
    "permission_id" integer NOT NULL REFERENCES "auth_permission" ("id"),
    UNIQUE ("user_id", "permission_id")
);
CREATE TABLE "auth_user" (
    "id" integer NOT NULL PRIMARY KEY,
    "password" varchar(128) NOT NULL,
    "last_login" datetime NOT NULL,
    "is_superuser" bool NOT NULL,
    "username" varchar(30) NOT NULL UNIQUE,
    "first_name" varchar(30) NOT NULL,
    "last_name" varchar(30) NOT NULL,
    "email" varchar(75) NOT NULL,
    "is_staff" bool NOT NULL,
    "is_active" bool NOT NULL,
    "date_joined" datetime NOT NULL
);
CREATE TABLE "django_content_type" (
    "id" integer NOT NULL PRIMARY KEY,
    "name" varchar(100) NOT NULL,
    "app_label" varchar(100) NOT NULL,
    "model" varchar(100) NOT NULL,
    UNIQUE ("app_label", "model")
);
CREATE TABLE "myapps_song" (
    "id" integer NOT NULL PRIMARY KEY,
    "title" varchar(50) NOT NULL
);
CREATE TABLE "myapps_user" (
    "id" integer NOT NULL PRIMARY KEY,
    "username" varchar(50) NOT NULL
);
CREATE TABLE "myapps_songuser" (
    "id" integer NOT NULL PRIMARY KEY,
    "song_id" integer NOT NULL REFERENCES "myapps_song" ("id"),
    "user_id" integer NOT NULL REFERENCES "myapps_user" ("id")
);
CREATE TABLE "reversion_revision" (
    "id" integer NOT NULL PRIMARY KEY,
    "manager_slug" varchar(200) NOT NULL,
    "date_created" datetime NOT NULL,
    "user_id" integer REFERENCES "auth_user" ("id"),
    "comment" text NOT NULL
);
CREATE TABLE "reversion_version" (
    "id" integer NOT NULL PRIMARY KEY,
    "revision_id" integer NOT NULL REFERENCES "reversion_revision" ("id"),
    "object_id" text NOT NULL,
    "object_id_int" integer,
    "content_type_id" integer NOT NULL REFERENCES "django_content_type" ("id"),
    "format" varchar(255) NOT NULL,
    "serialized_data" text NOT NULL,
    "object_repr" text NOT NULL
);
CREATE INDEX "auth_permission_37ef4eb4" ON "auth_permission" ("content_type_id");
CREATE INDEX "auth_group_permissions_5f412f9a" ON "auth_group_permissions" ("group_id");
CREATE INDEX "auth_group_permissions_83d7f98b" ON "auth_group_permissions" ("permission_id");
CREATE INDEX "auth_user_groups_6340c63c" ON "auth_user_groups" ("user_id");
CREATE INDEX "auth_user_groups_5f412f9a" ON "auth_user_groups" ("group_id");
CREATE INDEX "auth_user_user_permissions_6340c63c" ON "auth_user_user_permissions" ("user_id");
CREATE INDEX "auth_user_user_permissions_83d7f98b" ON "auth_user_user_permissions" ("permission_id");
CREATE INDEX "myapps_songuser_0cc685f0" ON "myapps_songuser" ("song_id");
CREATE INDEX "myapps_songuser_6340c63c" ON "myapps_songuser" ("user_id");
CREATE INDEX "reversion_revision_86395673" ON "reversion_revision" ("manager_slug");
CREATE INDEX "reversion_revision_6340c63c" ON "reversion_revision" ("user_id");
CREATE INDEX "reversion_version_0c5c14b2" ON "reversion_version" ("revision_id");
CREATE INDEX "reversion_version_33b489b4" ON "reversion_version" ("object_id_int");
CREATE INDEX "reversion_version_37ef4eb4" ON "reversion_version" ("content_type_id");



% sqlite3 -header -column db.sqlite3 'select * from reversion_revision;'
id          manager_slug  date_created                user_id     comment
----------  ------------  --------------------------  ----------  ----------
1           default       2014-06-28 11:40:22.404608

% sqlite3 -header -column db.sqlite3 'select * from reversion_version;'
id          revision_id  object_id   object_id_int  content_type_id  format      serialized_data                                                      object_repr
----------  -----------  ----------  -------------  ---------------  ----------  -------------------------------------------------------------------  -----------
1           1            1           1              5                json        [{"pk": 1, "model": "myapps.song", "fields": {"title": "title1b"}}]  Song object
2           1            2           2              7                json        [{"pk": 2, "model": "myapps.songuser", "fields": {"user": 3, "song"  SongUser ob
3           1            3           3              7                json        [{"pk": 3, "model": "myapps.songuser", "fields": {"user": 4, "song"  SongUser ob

"""
