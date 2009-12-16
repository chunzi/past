package Past::DB::Thing;
use strict;
use base qw( Past::DB::Object );
  
__PACKAGE__->meta->table('thing');
__PACKAGE__->meta->auto_initialize;

package Past::DB::Thing::Manager;
use base qw( Past::DB::Manager );

sub object_class { 'Past::DB::Thing' }
__PACKAGE__->make_manager_methods('things');


1;
