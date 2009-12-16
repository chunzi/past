package Past::DB::Object;
use strict;
 
use base qw( Rose::DB::Object );
use Rose::DB::Object::Helpers qw/ load_speculative /; 

use Past::DB;
       
sub init_db { Past::DB->new_or_cached }
 
1;
