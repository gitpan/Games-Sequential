# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl
# Games-Sequential-Position.t'

use Test::More tests => 10;

package My::Pos;
BEGIN { 
  use base Games::Sequential::Position;
};

sub _init {
    my $self = shift;
    my %config = (
        sum => 1
    );

    @$self{keys %config} = values %config;

    return $self->SUPER::_init(@_);
}

sub apply {
    my ($self, $m) = @_;
    return $self->{sum} += $m;
}


package main;
my ($p, $n);

ok($p = My::Pos->new,           "new()");
isa_ok($p, Games::Sequential::Position);

can_ok($p, qw/new _init copy/);

is($p->apply(1), 2,             "apply(1)");
is($p->apply(2), 4,             "apply(2)");
                       
is($p->apply(1), 5,             "apply(1)");
is($p->apply(1), 6,             "apply(1)");

ok($n = $p->copy,               "copy()");
is($n->apply(3), 9,             "apply(3)");

is($p->apply(3), 9,             "apply(3)");
