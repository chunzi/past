package Past::Web::Controller::Root;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Past;
use Class::Date qw / date/ ;

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

sub export :Local {
    my ( $self, $c ) = @_;
    my $past = new Past;
    my $thing = $past->things_for_days;
    my $out;
    my $bydays;
    map { 
        my $string = date($_->created)->string; 
        my ( $day, $time ) = split(/\s+/, $string);
        $time =~ s/:\d\d$//;

        push @{$bydays->{$day}}, { content => $_->content, time => $time, stamp => $_->created };
         } @$thing;
    for my $day ( sort keys %$bydays ){
        $out .= sprintf "\n%s:\n", $day;
        map { $out .= sprintf "- %s @%s\n", $_->{content}, $_->{time} } @{$bydays->{$day}};
    } 
    $c->res->body('<pre>'.$out.'</pre>');
}
sub delete :Local {
    my ( $self, $c ) = @_;
    my $json = { ok => 0 };
    if ( $c->req->method eq 'POST' ){
        my $past = new Past;
        my $thing = $past->get_thing( $c->req->param('tid'));
        defined $thing and $thing->delete;
        $json->{'ok'} = 1;
    }
    $c->stash->{'json'} = $json;
    $c->forward('View::JSON');
}

sub change :Local {
    my ( $self, $c ) = @_;
    my $json = { ok => 0 };
    my $past = new Past;
    my $thing = $past->get_thing( $c->req->param('tid') );
    if ( $c->req->method eq 'GET' ){
        $json->{'ok'} = 1;
        $json->{'html'} = $c->view('TT')->render($c, 'change.html', { thing => $thing });
    }elsif ( $c->req->method eq 'POST' ){
        $thing->content( $c->req->param('thing') );
        $thing->save;
        $json->{'ok'} = 1;
        $json->{'html'} = $c->view('TT')->render($c, 'thing_inner.html', { thing => $thing });
    }
        $json->{'testing'} = '中文';
        print STDERR $thing->content;
        $json->{'raw'} = $thing->content;
    $c->stash->{'json'} = $json;
    $c->forward('View::JSON');
}

sub thing :Local {
    my ( $self, $c ) = @_;
    my $past = new Past;
    my $thing = $past->get_thing( $c->req->param('tid') );
    $c->stash->{'thing'} = $thing;
    $c->stash->{'template'} = 'thing_inner.html';
}

sub end : ActionClass('RenderView') {}


1;
