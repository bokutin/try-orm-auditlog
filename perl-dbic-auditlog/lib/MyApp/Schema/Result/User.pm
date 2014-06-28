use utf8;
package MyApp::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->load_components(
  "InflateColumn::Serializer",
  "IntrospectableM2M",
  "TimeStamp",
  "AuditLog",
);
__PACKAGE__->table("user");
__PACKAGE__->add_columns(
  "id",
  { data_type => "serial", is_nullable => 0 },
  "username",
  { data_type => "varchar", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07040 @ 2014-06-28 03:47:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:LxDvzOIMnIxiFhLapCGXrw

__PACKAGE__->has_many( song_users => 'MyApp::Schema::Result::SongUser', 'user_id' );
__PACKAGE__->many_to_many( favorite_songs => 'song_users', 'song' );

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
