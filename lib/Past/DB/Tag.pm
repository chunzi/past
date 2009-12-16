package Past::DB::Tag;
use strict;
use base qw( Past::DB::Object );
  
__PACKAGE__->meta->table('tag');
__PACKAGE__->meta->unique_key('name');
__PACKAGE__->meta->auto_initialize;

package Past::DB::Tag::Manager;
use base qw( Past::DB::Manager );

sub object_class { 'Past::DB::Tag' }
__PACKAGE__->make_manager_methods('tags');


1;
