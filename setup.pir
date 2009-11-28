#! /usr/local/bin/parrot
# $Id$

=head1 NAME

setup.pir - Python distutils style

=head1 DESCRIPTION

No Configure step, no Makefile generated.

=head1 USAGE

    $ parrot setup.pir build
    $ parrot setup.pir test
    $ sudo parrot setup.pir install

=cut

.sub 'main' :main
    .param pmc args
    $S0 = shift args
    load_bytecode 'distutils.pbc'

    $P0 = new 'Hash'
    $P0['name'] = 'Kea'
    $P0['abstract'] = 'Kea - Factor on the Parrot Virtual Machine'
    $P0['authority'] = 'http://github.com/leto'
    $P0['description'] = 'Factor is a practical dynamic stack language. Parrot is a Virtual Machine designed to run dynamic languages.'
    $P0['license_type'] = 'Artistic License 2.0'
    $P0['license_uri'] = 'http://www.perlfoundation.org/artistic_license_2_0'
    $P0['copyright_holder'] = 'Parrot Foundation'
    $P0['checkout_uri'] = 'git://github.com/leto/kea.git'
    $P0['browser_uri'] = 'http://github.com/leto/kea'
    $P0['project_uri'] = 'http://github.com/leto/kea'

    # build
    $P4 = new 'Hash'
    $P5 = split ' ', 'src/parser/grammar.pg src/parser/grammar-oper.pg'
    $P4['src/gen_grammar.pir'] = $P5
    $P0['pir_pge'] = $P4

    $P6 = new 'Hash'
    $P6['src/gen_actions.pir'] = 'src/parser/actions.pm'
    $P0['pir_nqp'] = $P6

    $P7 = new 'Hash'
    $P8 = split "\n", <<'SOURCES'
kea.pir
src/gen_grammar.pir
src/gen_actions.pir
src/builtins.pir
src/builtins/dup.pir
src/builtins/say.pir
SOURCES
    $S0 = pop $P8
    $P7['kea.pbc'] = $P8
    $P0['pbc_pir'] = $P7

    $P9 = new 'Hash'
    $P9['parrot-kea'] = 'kea.pbc'
    $P0['installable_pbc'] = $P9

    # test
    $S0 = get_nqp()
    $P0['harness_exec'] = $S0

    .tailcall setup(args :flat, $P0 :flat :named)
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

