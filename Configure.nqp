# Purpose: Use Parrot's config info to configure our Makefile.
#
# Usage:
#     nqp Configure.nqp [input_makefile [output_makefile]]
#
# input_makefile  defaults to 'build/Makefile.in';
# output_makefile defaults to 'Makefile'.

our @ARGS;
our %VM;
our $OS;

MAIN();

sub MAIN () {
    # Wave to the friendly users
    say("Hello, I'm Configure. My job is to poke and prod\nyour system to figure out how to build Kea.\n");

    # Load Parrot config and glue functions
    pir::load_bytecode('PGE.pbc');
    pir::load_bytecode('src/lib/Glue.pir');

    # Slurp in the unconfigured Makefile text
    my $unconfigured := slurp(@ARGS[0] || 'build/Makefile.in');

    # Replace all of the @foo@ markers
    my $replaced := subst($unconfigured, rx('\@<ident>\@'), replacement);

    # Fix paths on Windows
    if ($OS eq 'MSWin32') {
        $replaced := subst($replaced, rx('\/'),     '\\'   );
        $replaced := subst($replaced, rx('\\\\\*'), '\\\\*');
    }

    # Spew out the final makefile
    spew(@ARGS[1] || 'Makefile', $replaced);

    # Give the user a hint of next action
    my $make := %VM<config><make>;
    say("Configure completed for platform '$OS'.");
    say("You can now type '$make' to build Kea.\n");
    say("You may also type '$make test' to run the Kea test suite.\n");
    say("Happy Hacking,\n\tThe Kea Team");
}

sub replacement ($match) {
    my $key    := $match<ident>;
    my $config := %VM<config>{$key} || '';

    return $config;
}
