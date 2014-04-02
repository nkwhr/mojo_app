package MyApp::Controller::User;
use Mojo::Base 'Mojolicious::Controller';

sub index {
    my $self = shift;

    my $users = $self->model('User')->find_all();

    $self->respond_to(
        json => {json => $users},
        html => {template => 'user/index', users => $users},
    );
}

sub new_user {
    my $self = shift;
    $self->render('user/new')
}

sub show {
    my $self = shift;

    my $user = $self->model('User')->find({
        where => {
            id => $self->stash('id'),
        },
    });

    $self->respond_to(
        json => {json => $user},
        html => {template => 'user/show', user => $user},
    );
}

sub create {
    my $self = shift;

    my $user_params = {
        name  => $self->param('name'),
        email => $self->param('email'),
    };

    my $errors = $self->model('User')->create($user_params);

    if ($errors) {
        $self->flash(danger => $errors);
        $self->redirect_to('/user/new');
    } else {
        $self->flash(success => 'User was successfully created.');
        $self->redirect_to('/user');
    }
}

sub edit {
    my $self = shift;

    my $user = $self->model('User')->find({
        where => {
            id => $self->stash('id'),
        },
    });

    $self->stash->{user} = $user;
    $self->render('user/edit');
}

sub update {
    my $self = shift;

    my $id = $self->stash('id');

    my $user_params = {
        id    => $id,
        name  => $self->param('name'),
        email => $self->param('email'),
    };

    my $errors = $self->model('User')->update($user_params, {id => $id});

    if ($errors) {
        $self->flash(danger => $errors);
        $self->redirect_to("/user/$id/edit");
    } else {
        $self->flash(success => 'User was successfully updated.');
        $self->redirect_to('/user');
    }

}

sub destroy {
    my $self = shift;
    my $id = $self->stash('id');

    my $errors = $self->model('User')->destory({id => $id});

    if ($errors) {
        $self->flash(danger => $errors);
    } else {
        $self->flash(success => 'User was successfully deleted.');
    }

    $self->redirect_to('/user');
}

1;
