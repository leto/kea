#! perl

=head1 TITLE

gen_parrot.pl - script to obtain and build Parrot for kea

=head2 SYNOPSIS

    perl gen_parrot.pl [--option-for-Configure-pl]

=head2 DESCRIPTION

Maintains an appropriate copy of Parrot in the parrot/ subdirectory.
The revision of Parrot to be used in the build is given by the
build/PARROT_REVISION file.

=cut

use strict;
use warnings;
use 5.008;

##  determine what revision of Parrot we require
open my $REQ, 'build/PARROT_REVISION'
    or die "cannot open build/PARROT_REVISION ($!)\n";
my $required = <$REQ>;
chomp $required;
close $REQ;

{
    no warnings;
    if (open my $REV, '-|', 'parrot/parrot_config revision') {
        my $revision = <$REV>;
        close $REV;
        chomp $revision;
        if ($revision >= $required) {
            print "Parrot r$revision already available (r$required required)\n";
            exit(0);
        }
    }
}

print "Checking out Parrot r$required via svn...\n";
system("svn checkout -r $required https://svn.parrot.org/parrot/trunk parrot");

chdir('parrot');


##  If we have a Makefile from a previous build, do a 'make realclean'
if (-f 'Makefile') {
    my %config = read_parrot_config();
    my $make = $config{'make'};
    if ($make) {
        print "Performing '$make realclean'\n";
        system($make, 'realclean');
    }
}

##  Configure Parrot
system($^X, 'Configure.pl', @ARGV);

my %config = read_parrot_config();
my $make = $config{'make'};
system( $make );
system( $make, 'install-dev' );

sub read_parrot_config {
    my %config = ();
    if (open my $CFG, 'config_lib.pasm') {
        while (<$CFG>) {
            $config{$1} = $2 if (/P0\["(.*?)"], "(.*?)"/);
        }
        close $CFG;
    }
    %config;
}

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:

