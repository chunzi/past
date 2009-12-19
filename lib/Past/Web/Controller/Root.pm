package Past::Web::Controller::Root;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Past;

__PACKAGE__->config->{namespace} = '';

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    my $past = new Past;
    $c->stash->{'today'} = $past->things_for_day;
    $c->stash->{'template'} = 'index.html';
}

sub default :Path {
    my ( $self, $c ) = @_;
    $c->res->body( 'Page not found' );
    $c->res->status(404);
}

sub new_thing :Path('new') {
    my ( $self, $c ) = @_;
    if ( $c->req->method eq 'POST' ){
        my $past = new Past;
        my $content = $c->req->param('thing');
        my $thing = $past->thing( $content );
        $c->stash->{'thing'} = $thing;
        $c->stash->{'template'} = 'thing.html';
    }else{
        $c->res->body('');
    }
}

sub end : ActionClass('RenderView') {}


1;
