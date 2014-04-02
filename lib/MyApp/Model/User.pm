package MyApp::Model::User;
use Mojo::Base 'MyApp::Model::Base';

use constant {
    TABLE => 'users',
};

use Time::Piece;
use FormValidator::Lite qw/Email/;

sub find_all {
    my ($self, $args) = @_;

    $self->_find_all(TABLE, $args);
}

sub find {
    my ($self, $args) = @_;

    $self->_find(TABLE, $args)
}

sub create {
    my ($self, $params) = @_;

    if (my $errors = $self->_validate_inputs($params)) {
        return $errors;
    }

    my $now = Time::Piece::localtime->strftime('%Y-%m-%d %H:%M:%S');
    $params->{created_at} = $now;
    $params->{updated_at} = $now;

    $self->_create(TABLE, $params);
}

sub update {
    my ($self, $params, $where) = @_;

    if (my $errors = $self->_validate_inputs($params)) {
        retrun $errors;
    }

    my $now = Time::Piece::localtime->strftime('%Y-%m-%d %H:%M:%S');
    $params->{updated_at} = $now;

    delete $params->{id};

    $self->_update(TABLE, $params, $where);
}

sub destory {
    my ($self, $where) = @_;

    $self->_destroy(TABLE, $where);
}

sub _validate_inputs {
    my ($self, $params) = @_;

    my $validator = FormValidator::Lite->new($params);

    $validator->check(
        name  => [qw/NOT_NULL/],
        email => [qw/NOT_NULL EMAIL_LOOSE/]
    );

    $validator->set_message(
        'name.not_null'     => 'Name field is empty.',
        'email.not_null'    => 'Email field is empty.',
        'email.email_loose' => 'Email format is invalid.',
    );

    if ($validator->has_error) {
        my $errors = $validator->get_error_messages;
        return join " ", @$errors;
    }

    return undef;
}

1;
