package Games::Sequential::Position;
use strict;
use warnings;

use Carp;
use Data::Dumper;
use 5.006001;

our $VERSION = '0.1';

=head1 NAME

Games::Sequential::Position - base Position class for use with
Games::Sequential & Games::AlphaBeta

=head1 SYNOPSIS

  package Some::Game::Position;
  use base Games::Sequential::Position;

  sub apply { ... }

  package main;
  my $pos = Some::Game::Position->new;
  my $game = Games::Sequential->new($pos);


=head1 DESCRIPTION

Games::Sequential::Position is a simple base class for a
position-object for use with Games::Sequential. This class is
provided only For convenience, and provides the ->copy() method.
Users do not have to inherit this class to use Games::Sequential;
it is only provided for convenience. 

=head1 REQUIRED USER-DEFINED METHODS

Anyone inheriting this class for use with Games::Sequential must
implement at least the ->apply() method. If you chose to not use
this class, you must also implement a ->copy() method which makes
a deep copy of the object.

The ->apply() method will probably look something along these
lines (sans error checking):

  sub apply {
    my ($self, $move) = @_;

    ... apply $move, creating next position ...

    return $self;
  }

=head1 OPTIONAL USER-DEFINED METHODS

For use with Games::AlphaBeta three more methods must be
implemented. These are:

=over 4

=item findmoves()
    
Return an array of all moves possible for the current player at
the current position. Don't forget to include null moves if the
player is allowed to pass.

=item endpos()

True if the position is an ending position, i.e. either a draw or
a win for one of the players.

=item evaluate()

Return the "fitness" value for the current player at the current
position.

=back

=head1 METHODS

These methods are supplied by this base class:

=over 4

=item new [@list]

Create and return a new object. Any arguments is passed on to the
overridable _init() method.

=cut 

sub new {
    my $invocant = shift;
    my $class = ref($invocant) || $invocant;
    my $self = bless {}, $class;

    $self->_init(@_) or carp "Failed to init object!";
    croak "no apply() method defined" unless $self->can("apply");

    return $self;
}


=item _init [@list]

I<Internal method>

Initialize an object. This method is called by ->new(), so you do
not have to override that. You probably want to override this
though. You might want to call C<$self->SUPER::_init(@_);> from
within your version of the method.

=cut

sub _init {
    my $self = shift;
    my $args = @_ && ref($_[0]) ? shift : { @_ };

    # Override defaults
    while (my ($key, $val) = each %{ $args }) {
        $self->{$key} = $val if exists $self->{$key};
    }

    return $self;
}


=item copy

Return a deep copy of the object.

=cut

sub copy {
    local $Data::Dumper::Purity = 1;
    local $Data::Dumper::Deepcopy = 1;
    local $Data::Dumper::Indent = 0;

    no strict "vars";
    return eval Dumper($_[0]);
}

1;  # ensure using this module works
__END__

=back

=head1 SEE ALSO

The author's website, describing this and other projects:
http://brautaset.org/projects/

=head1 AUTHOR

Stig Brautaset, E<lt>stig@brautaset.orgE<gt>

=head1 COPYRIGHT AND LICENCE

Copyright (C) 2004 by Stig Brautaset

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.3 or,
at your option, any later version of Perl 5 you may have available.

=cut

# vim: shiftwidth=4 tabstop=4 softtabstop=4 expandtab 
