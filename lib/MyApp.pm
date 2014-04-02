package MyApp;
use Mojo::Base 'Mojolicious';
use Mojo::Loader;

sub startup {
    my $self = shift;

    my $mode = $ENV{MOJO_MODE} || 'development';
    $self->mode($mode);

    $self->app->log->level('debug');
    $self->secrets(['newsecret_password']);

    $self->sessions->default_expiration(60 * 60);

    $self->plugin('charset'   => {charset => 'UTF-8'});
    $self->plugin('AssetPack' => {cleanup => 1});

    $self->asset(
        'app.css' =>
            '/assets/stylesheets/bootstrap.css',
            '/assets/stylesheets/font-awesome.css',
            '/assets/stylesheets/main.css',
    );
    $self->asset(
        'app.js' =>
            '/assets/javascripts/jquery-1.11.0.js',
            '/assets/javascripts/bootstrap.js',
    );

    $self->hook(
        before_dispatch => sub {
            my $c = shift;
            if (my $_method = $c->req->param('_method')) {
                $c->req->method(uc $_method);
            }
        }
    );

    $self->_preload_models;
    $self->_setup_routes;

    $self->helper(model =>sub {
        my ($self, $name) = @_;
        unless ($self->{_model}->{$name}) {
            my $module = "MyApp::Model::$name";
            $self->{_model}->{$name}= $module->new;
        }
        return $self->{_model}->{$name};
    });
}

sub _preload_models {
    my $self = shift;
    my $loader = Mojo::Loader->new;
    for my $module (@{$loader->search('MyApp::Model')}) {
        my $e = $loader->load($module);
        die ref $e ? "Exception: $e" : 'Already loaded!' if $e;
    }
}

sub _setup_routes {
    my $self = shift;
    my $r = $self->routes;
    push @{$r->namespaces}, 'MyApp::Controller';

    $r->get('/')->to('root#index')->name('root_path');

    $r->get('/user')          ->to('user#index')    ->name('user_path');
    $r->post('/user')         ->to('user#create')   ->name('create_user_path');
    $r->get('/user/new')      ->to('user#new_user') ->name('new_user_path');
    $r->get('/user/:id')      ->to('user#show')     ->name('show_user_path');
    $r->get('/user/:id/edit') ->to('user#edit')     ->name('edit_user_path');
    $r->put('/user/:id')      ->to('user#update')   ->name('update_user_path');
    $r->delete('/user/:id')   ->to('user#destroy')  ->name('destroy_user_path');
}

1;
