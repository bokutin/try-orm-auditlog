#!/usr/bin/env perl

use rlib;
use Modern::Perl;
use MyApp::Container qw(container);
use List::Compare;
use YAML::Syck;

unlink "song.db";
system("sqlite3 song.db < ../share/schema.sql");

sub showing {

    my $schema = container('schema');
    for my $song ($schema->resultset('Song')->all) {
        say "Song: " . $song->title;
        for my $user ($song->fans) {
            say "    User: " . $user->username;
        }
    }
}

say "--> showing";
showing();
say "";

say "--> modify";
{
    my $schema = container('schema');
    $schema->txn_do(
        sub {
            my $song = $schema->resultset('Song')->find( { title => 'title1' } );
            my @fans = $schema->resultset('User')->search( { username => [qw(username1 username3 username4)] } );
            $song->update( { title => "title1a" } );
            $song->set_fans( @fans );
        },
        {
            description => 'modify',
        }
    );
}
say "";

say "--> audit trace";
{
    my $schema = container('schema');
    my $al_schema = $schema->audit_log_schema;
    for (sort $al_schema->sources) {
        say "$_: @{[ $al_schema->resultset($_)->count ]}";
    }

    my $changeset = $al_schema->resultset('AuditLogChangeset')->first;
    for my $action ($changeset->Action) {
        say "==> Action";
        say( (Dump { $action->get_columns }) =~ s/^/    /mgr );
        for my $change ($action->Change) {
            say "    ==> Change";
            say( (Dump { $action->get_columns }) =~ s/^/        /mgr );
        }
    }
}
say "";

say "--> audit display";
{
    my $schema = container('schema');
    my $al_schema = $schema->audit_log_schema;
    my $changeset = $al_schema->resultset('AuditLogChangeset')->first;

    for my $table (qw(song song_user)) {
        my @actions = $al_schema->resultset('AuditLogAction')->search(
            {
                changeset_id => $changeset->id,
                name         => $table,
            },
            {
                join => 'AuditedTable',
            },
        );
        for my $action (@actions) {
            say sprintf("%s %s (%s)", $action->action_type, $action->AuditedTable->name, 
                join( ", ", map { $_->Field->name . ":" . ($_->old_value//"NULL") . '->' . ($_->new_value//"NULL") } $action->Change),
            );
        }
    }

    {
        my @changes = $al_schema->resultset('AuditLogChange')->search(
            {
                changeset_id => $changeset->id,
                name         => 'song_user',
            },
            {
                join => { Action => 'AuditedTable' },
            },
        );
        my @old_fans = grep $_, map { $_->old_value } @changes;
        my @new_fans = grep $_, map { $_->new_value } @changes;
        my $lc = List::Compare->new( \@old_fans, \@new_fans );
        say "fans: " . join ", ", map { "-".$_->username } map { $schema->resultset('User')->find($_) } $lc->get_Lonly;
        say "fans: " . join ", ", map { "+".$_->username } map { $schema->resultset('User')->find($_) } $lc->get_Ronly;
    }
}
say "";

say "--> showing";
showing();
say "";

__END__

% ./script/try_audit.pl
--> showing
Song: title1
    User: username1
    User: username2

--> modify

--> audit trace
AuditLogAction: 6
AuditLogAuditedTable: 2
AuditLogChange: 11
AuditLogChangeset: 1
AuditLogField: 3
AuditLogUser: 0
AuditLogView: 11
==> Action
    --- 
    action_type: update
    audited_row: 1
    audited_table_id: 1
    changeset_id: 1
    id: 1

    ==> Change
        --- 
        action_type: update
        audited_row: 1
        audited_table_id: 1
        changeset_id: 1
        id: 1

==> Action
    --- 
    action_type: delete
    audited_row: 1-1
    audited_table_id: 2
    changeset_id: 1
    id: 2

    ==> Change
        --- 
        action_type: delete
        audited_row: 1-1
        audited_table_id: 2
        changeset_id: 1
        id: 2

    ==> Change
        --- 
        action_type: delete
        audited_row: 1-1
        audited_table_id: 2
        changeset_id: 1
        id: 2

==> Action
    --- 
    action_type: delete
    audited_row: 1-2
    audited_table_id: 2
    changeset_id: 1
    id: 3

    ==> Change
        --- 
        action_type: delete
        audited_row: 1-2
        audited_table_id: 2
        changeset_id: 1
        id: 3

    ==> Change
        --- 
        action_type: delete
        audited_row: 1-2
        audited_table_id: 2
        changeset_id: 1
        id: 3

==> Action
    --- 
    action_type: insert
    audited_row: 1-1
    audited_table_id: 2
    changeset_id: 1
    id: 4

    ==> Change
        --- 
        action_type: insert
        audited_row: 1-1
        audited_table_id: 2
        changeset_id: 1
        id: 4

    ==> Change
        --- 
        action_type: insert
        audited_row: 1-1
        audited_table_id: 2
        changeset_id: 1
        id: 4

==> Action
    --- 
    action_type: insert
    audited_row: 1-3
    audited_table_id: 2
    changeset_id: 1
    id: 5

    ==> Change
        --- 
        action_type: insert
        audited_row: 1-3
        audited_table_id: 2
        changeset_id: 1
        id: 5

    ==> Change
        --- 
        action_type: insert
        audited_row: 1-3
        audited_table_id: 2
        changeset_id: 1
        id: 5

==> Action
    --- 
    action_type: insert
    audited_row: 1-4
    audited_table_id: 2
    changeset_id: 1
    id: 6

    ==> Change
        --- 
        action_type: insert
        audited_row: 1-4
        audited_table_id: 2
        changeset_id: 1
        id: 6

    ==> Change
        --- 
        action_type: insert
        audited_row: 1-4
        audited_table_id: 2
        changeset_id: 1
        id: 6


--> audit display
update song (title:title1->title1a)
delete song_user (song_id:1->NULL, user_id:1->NULL)
delete song_user (song_id:1->NULL, user_id:2->NULL)
insert song_user (song_id:NULL->1, user_id:NULL->1)
insert song_user (song_id:NULL->1, user_id:NULL->3)
insert song_user (song_id:NULL->1, user_id:NULL->4)
fans: -username2
fans: +username3, +username4

--> showing
Song: title1a
    User: username1
    User: username3
    User: username4

