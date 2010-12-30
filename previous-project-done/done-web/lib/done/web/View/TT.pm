package done::web::View::TT;

use strict;
use base 'Catalyst::View::TT';

__PACKAGE__->config({
    COMPILE_DIR  => '/tmp',
    INCLUDE_PATH => [
        done::web->path_to( 'root', 'templates' ),
    ],
    PRE_PROCESS  => 'pre_process',
    TIMER        => 1,
});


=head1 NAME

done::web::View::TT - TT View for done::web

=head1 DESCRIPTION

TT View for done::web. 

=head1 AUTHOR

=head1 SEE ALSO

L<done::web>

chunzi,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
