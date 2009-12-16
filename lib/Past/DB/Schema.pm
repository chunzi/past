package Past::DB::Schema;
use Any::Moose;
 
__PACKAGE__->meta->make_immutable;
 
no Any::Moose;
 
use Past::DB;
 
sub install {
    my $class = shift;
 
    my $db = Past::DB->new;
    my $dbh = $db->dbh;
    $dbh->do("$_;") for split /;\s+/, <<'SQL';

CREATE TABLE thing (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  content TEXT NOT NULL,
  created INTEGER
);

CREATE TABLE tag (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL
);
CREATE UNIQUE INDEX tag ON tag (name);

SQL
}
 
sub upgrade {
    my $class = shift;
 
    my $db = Past::DB->new;
    my $dbh = $db->dbh;
    my $sth = $dbh->prepare("SELECT name FROM sqlite_master WHERE type IN (?)");
    $sth->execute('table');
 
    my %tables;
    while (my $row = $sth->fetchrow_arrayref) {
        $tables{$row->[0]} = 1;
    }
 
    unless ($tables{track}) {
        $class->install();
    }
 
    return 1;
}
 
1;
