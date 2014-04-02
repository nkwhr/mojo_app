package MyApp::Controller::Root;
use Mojo::Base 'Mojolicious::Controller';

sub index {
    my $self = shift;
    $self->render('root/index');
}

1;
