=head1 TITLE

kea.pir - A kea compiler.

=head2 Description

This is the base file for the kea compiler.

This file includes the parsing and grammar rules from
the src/ directory, loads the relevant PGE libraries,
and registers the compiler under the name 'kea'.

=head2 Functions

=over 4

=item onload()

Creates the kea compiler using a C<PCT::HLLCompiler>
object.

=cut

.namespace [ 'kea::Compiler' ]

#.loadlib 'kea_group'

.sub 'onload' :anon :load :init
    load_bytecode 'PCT.pbc'

    $P0 = get_hll_global ['PCT'], 'HLLCompiler'
    $P1 = $P0.'new'()
    $P1.'language'('kea')
    $P1.'parsegrammar'('kea::Grammar')
    $P1.'parseactions'('kea::Grammar::Actions')

    $P1.'commandline_banner'("Kea - Factor on Parrot Virtual Machine\n")
    $P1.'commandline_prompt'('> ')
.end

=item main(args :slurpy)  :main

Start compilation by passing any command line C<args>
to the kea compiler.

=cut

.sub 'main' :main
    .param pmc args

    $P0 = compreg 'kea'
    $P1 = $P0.'command_line'(args)
.end

.include 'src/gen_builtins.pir'
.include 'src/gen_grammar.pir'
.include 'src/gen_actions.pir'

=back

=cut

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

