package MyApp::Schema::ResultSet::SongUser;

use base 'DBIx::Class::ResultSet';

__PACKAGE__->load_components("ResultSet::AuditLog");

1;
