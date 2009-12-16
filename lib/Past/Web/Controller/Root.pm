package Past::Web::Controller::Root;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Past;

__PACKAGE__->config->{namespace} = '';

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    my $past = new Past;
    if ( $c->req->method eq 'POST' ){
        my $content = $c->req->param('thing');
        my $thing = $past->thing( $content );
    }

    $c->stash->{'today'} = $past->things_for_day;
    $c->stash->{'template'} = 'index.html';
}

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}


sub end : ActionClass('RenderView') {}


1;
