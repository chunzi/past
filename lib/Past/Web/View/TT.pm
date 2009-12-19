package Past::Web::View::TT;

use strict;
use base 'Catalyst::View::TT';

__PACKAGE__->config(
    INCLUDE_PATH       => [ Past::Web->path_to('root', 'template'), ],
    TEMPLATE_EXTENSION => '.html',
    PRE_PROCESS        => 'pre.tt',
); 

1;
