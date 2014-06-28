use utf8;
package MyApp::Schema::Result::SongUser;

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
__PACKAGE__->table("song_user");
__PACKAGE__->add_columns(
  "song_id",
  { data_type => "integer", is_nullable => 0 },
  "user_id",
  { data_type => "integer", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("song_id", "user_id");


# Created by DBIx::Class::Schema::Loader v0.07040 @ 2014-06-28 03:47:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ldZEa/yijmU319t8+BC3bw

__PACKAGE__->belongs_to( song => 'MyApp::Schema::Result::Song', 'song_id' );
__PACKAGE__->belongs_to( user => 'MyApp::Schema::Result::User', 'user_id' );

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
