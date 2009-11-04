# $Id$

=head1

dup.pir -- simple implementation of a dup function

=cut

.namespace []
.sub main
    #.global pmc stack
    #stack = new 'ResizablePMCArray'
.end

.sub 'dup'
    $P0   = new 'Integer'
    $P0   = 42
    say 'Dupe!'
    #push stack, $P0
    #push stack, $P0
    .return ()
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

