package Past::Web::View::JSON;

use strict;
use base 'Catalyst::View::JSON';
use JSON::Syck;


sub encode_json {
    my ($self, $c, $data) = @_;
    return JSON::Syck::Dump($data);
}

1;
