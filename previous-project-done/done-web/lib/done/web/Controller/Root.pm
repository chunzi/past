package done::web::Controller::Root;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use lib '/home/chunzi/chunzi-code/toys/done/lib';
use done;

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config->{namespace} = '';

=head1 NAME

done::web::Controller::Root - Root Controller for done::web

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=cut

=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{'template'} = 'layout.html';
    $c->forward('View::TT');
}

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
    
}

sub post :Local {
    my ( $self, $c ) = @_;
    my $done = new done;
    my $thing = $done->parse( $c->req->param('content') );
    $done->save( $thing ); 
    $c->res->body('ok');
}

sub things :Local {
    my ( $self, $c ) = @_;
    my $done = new done;
    my $things = $done->things_of_day();
    $c->stash->{'things'} = $things;
    $c->stash->{'template'} = 'things.html';
    $c->forward('View::TT');
}
=head2 end

Attempt to render a view, if needed.

=cut 

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

chunzi

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
