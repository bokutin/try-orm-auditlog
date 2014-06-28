package MyApp::Container;

use Modern::Perl;

use Exporter 'import';
our @EXPORT_OK = qw(container);

our $INSTANCE;

sub instance {
    my $class = shift;
    $INSTANCE ||= $class->new(@_);
}

sub new {
    my $class = shift;
    my $self  = bless {}, $class;
}

sub container {
    my $self = __PACKAGE__->instance;
    my $method = shift;
    $self->$method(@_);
}

################################################################################

sub app_home {
    my $self = shift;

    $self->{_app_home} ||= do {
        require File::Basename;
        require File::Spec;
        my $dir = File::Spec->catfile( File::Basename::dirname(__FILE__), '../..' );
    };
}

sub config {
    my $self = shift;

    $self->{_config} ||= do {
        require File::Basename;
        require File::Spec;
        my $dbfile = File::Spec->catfile( $self->app_home, 'song.db' );
        +{
            schema => {
                connect_info => {
                    dsn            => "dbi:SQLite:dbname=$dbfile",
                    user           => "",
                    password       => "",
                },
            },
        };
    };
}

sub schema {
    my $self = shift;

    $self->{_schema} ||= do {
        require Module::Runtime;
        my $config = $self->config->{schema} || die;
        my $schema_class = 'MyApp::Schema';
        Module::Runtime::require_module($schema_class);
        my $connect_info = $config->{connect_info} || die;
        my $schema = $schema_class->connect( ref($connect_info) eq 'ARRAY' ? @$connect_info : $connect_info );

        my $al_schema = $schema->audit_log_schema;
        $al_schema->deploy;

        $schema;
    };
}

1;
