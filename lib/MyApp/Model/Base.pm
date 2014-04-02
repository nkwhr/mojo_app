package MyApp::Model::Base;
use Mojo::Base -base;

use DBIx::Sunny;
use SQL::Maker;
use Carp qw/croak/;

my $mode   = $ENV{MOJO_MODE} || 'development';
my $config = do "conf/$mode.pl" or die "Can not load config. $!";

has 'db' => sub {
    DBIx::Sunny->connect(@{$config->{db}});
};

has 'builder' => sub {
    SQL::Maker->load_plugin('JoinSelect');
    SQL::Maker->new(driver => 'SQLite');
};

# has 'cache' => sub {
#     Cache::Memcached::Fast->new($config->{memcached});
# };
#
# has 'redis' => sub {
#     Redis->new(%{$config->{redis}});
# };

sub _find_all {
    my ($self, $table, $args) = @_;

    my $fields  = $args->{fields}  || ['*'];
    my $where   = $args->{where}   || [];
    my $options = $args->{options} || {};

    my ($sql, @binds) = $self->builder->select($table, $fields, $where, $options);
    $self->db->select_all($sql, @binds);
}

sub _find {
    my ($self, $table, $args) = @_;

    my $result = $self->_find_all($table, $args);
    croak "Result contains multiple rows" if scalar @$result != 1;

    $result->[0];
}

sub _create {
    my ($self, $table, $params) = @_;

    my ($sql, @binds) = $self->builder->insert($table, $params);
    return undef if $self->db->query($sql, @binds) == 1;
}

sub _update {
    my ($self, $table, $params, $where) = @_;

    my ($sql, @binds) = $self->builder->update($table, $params, $where);
    return undef if $self->db->query($sql, @binds) == 1;
}

sub _destroy {
    my ($self, $table, $where) = @_;

    my ($sql, @binds) = $self->builder->delete($table, $where);
    return undef if $self->db->query($sql, @binds) == 1;
}

1;
