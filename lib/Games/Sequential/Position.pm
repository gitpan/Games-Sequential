package Games::Sequential::Position;
use strict;
use warnings;

use Carp;
use Data::Dumper;
use 5.006001;

our $VERSION = '0.1';

=head1 NAME

Games::Sequential::Position - base Position class for use with Games::Sequential 

=head1 SYNOPSIS

    package My::GamePos;
    use base Games::Sequential::Position;

    sub _init { ... }   # setup initial state
    sub apply { ... }

    package main;
    my $pos = My::GamePos->new;
    my $game = Games::Sequential->new($pos);


=head1 DESCRIPTION

Games::Sequential::Position is a base class for position-classes
that can be used with L<Games::Sequential>. This class is
provided for convenience; you don't need this class to use
C<Games::Sequential>. It is also possible to use this class on
its own.

=head1 MISSING METHODS

Modules inheriting this class must implement at least the
C<apply()> method. If you chose to not use this class, you must
also implement a C<copy()> method which makes a deep copy of the
object.

=over 4

=item apply $move

Accept a move and apply it to the current state producing the
next state. Return a reference to itself.

Something like this (sans error checking):

    sub apply {
        my ($self, $move) = @_;

        ... apply $move, creating next position ...

        return $self;
    }

=back


=head1 METHODS

The following methods are provided by this class.

=over 4

=item new [@list]

Create and return an object. Any arguments is passed on to the
C<_init()> method. Return a blessed hash reference.

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

I<Internal method.>

Initialize an object. This method is called by C<new()>, so you
do not have to override that. You probably want to override this
though. You might want to call C<$self->SUPER::_init(@_)> from
within the overriding method.

=cut

sub _init {
    my $self = shift;
    my $args = @_ && ref($_[0]) ? shift : { @_ };
    my %config = (
        player      => 1,
    );

    @$self{keys %config} = values %config;

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


=item dump

Return a string dump (by Data::Dumper) of the current position.

=cut

sub dump {
    return Dumper(shift);
}



=item player [$player]

Read and/or set the current player. If argument is given, that
will be set to the current player.

=cut

sub player {
    my $self = shift;
    $self->{player} = shift if @_;
    return $self->{player};
}



1;  # ensure using this module works
__END__

=back


=head1 SEE ALSO

The author's website, describing this and other projects:
L<http://brautaset.org/projects/>


=head1 AUTHOR

Stig Brautaset, E<lt>stig@brautaset.orgE<gt>


=head1 COPYRIGHT AND LICENCE

Copyright (C) 2004 by Stig Brautaset

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.3 or,
at your option, any later version of Perl 5 you may have available.

=cut

# vim: shiftwidth=4 tabstop=4 softtabstop=4 expandtab 
