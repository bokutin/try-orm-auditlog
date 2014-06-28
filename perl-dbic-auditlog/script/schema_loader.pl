#!/usr/bin/env perl

use rlib;
use Modern::Perl;

use DBIx::Class::Schema::Loader qw(make_schema_at);
use MyApp::Container qw(container);

make_schema_at(
    'MyApp::Schema',
    {
        #debug => 1,
        #constraint => '^foo.*',
        dump_directory => './lib',

        components => [
            "InflateColumn::Serializer",
            "IntrospectableM2M",
            "TimeStamp"
        ],
        generate_pod => 0,
        result_component_map => {
            Song     => [ "AuditLog" ],
            SongUser => [ "AuditLog" ],
            User     => [ "AuditLog" ],
        },
        schema_components => [
            "Schema::AuditLog",
        ],
        use_namespaces => 1,
    },
    [ 
        container('config')->{schema}{connect_info},
    ],
);
