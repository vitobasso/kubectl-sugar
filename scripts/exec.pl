#!/usr/bin/perl
use v5.12;
use FindBin qw($RealBin);
use lib $RealBin;
use Common::Command qw(run_attach find_do_retry);
use Getopt::Long qw(GetOptions);
use Expect;

sub help {
   say "Usage: kexe <pod search terms> [-c container]";
   say "";
   say "Examples:";
   say "\tkexe namespace tool";
   say "\tkexe tool";
}
help and exit unless @ARGV;

my $container;
GetOptions('container|c=s' => \$container) or help and exit;

find_do_retry("pod @ARGV", \&exec, "any pods");

sub exec {
    my ($ns, undef, $pod) = @_;
    my $command = "kubectl -n $ns exec -it $pod -- bash";
    $command = $command . " -c $container" if $container;
    run_attach($command);
}
