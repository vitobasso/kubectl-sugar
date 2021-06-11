#!/usr/bin/perl
use v5.12;
use FindBin qw($RealBin);
use lib $RealBin;
use Common::Command qw(run find_do_retry);
use Expect;

sub help {
   say "Usage: kdes <pod search terms>";
   say "";
   say "Examples:";
   say "\tkdes namespace my-cool-app";
   say "\tkdes app";
}
help and exit unless @ARGV;

find_do_retry(join(" ", @ARGV), \&describe, "anything");

sub describe {
    my ($ns, $type, $name) = @_;
    my $result = run("kubectl -n $ns describe $type/$name");
    say "\n$result" if $result;
}
