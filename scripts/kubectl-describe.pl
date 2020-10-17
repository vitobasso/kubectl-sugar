#!/usr/bin/perl
use v5.12;
use FindBin qw($RealBin);
use Expect;

sub help {
   say "Usage: kdesc <pod search terms>";
   say "Examples";
   say "\tkdesc dap lap-dog";
   say "\tkdesc dog dap";
   say "\tkdesc dog";
}

help and exit unless @ARGV;

my $should_retry = "once";
find_and_describe();

sub find_and_describe {
   my @result = `$RealBin/kubectl-find.pl @ARGV`;
   if(scalar @result == 1) {
      my ($ns, $res, $pod) = split " ", shift @result;
      my $command = "kubectl -n $ns describe $res/$pod";
      say $command;
      my $result = `$command`;
      say "\n$result" if $result;
      retry($ns) if $?==256 and $should_retry;
   } elsif (not @result) {
      say "Can't find anything matching: @ARGV";
   } else {
      print @result; # list matching resources
   }
}

sub retry {
   undef $should_retry;
   my $ns = shift;
   print `$RealBin/kubectl-get.pl -q pod $ns`;
   find_and_describe();
}
