# $Id$

=head1

dup.pir -- simple implementation of a dup function

=cut

.namespace []
    .local pmc stack
    stack = new 'ResizablePMCArray'

.sub 'dup'
    $P0 = stack[0]
    push stack, $P0
    .return ()
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

