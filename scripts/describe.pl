#!/usr/bin/perl
use v5.12;
use FindBin qw($RealBin);
use Expect;

sub help {
   say "Usage: kdesc <pod search terms>";
   say "";
   say "Examples:";
   say "\tkdesc namespace my-cool-app";
   say "\tkdesc namespace app";
   say "\tkdesc app";
}

help and exit unless @ARGV;

my $should_retry = "once";
find_and_describe();

sub find_and_describe {
   my @result = `$RealBin/find.pl @ARGV`;
   if(scalar @result == 1) {
      my ($ns, $res, $pod) = split " ", shift @result;
      my $command = "kubectl -n $ns describe $res/$pod";
      say $command;
      my $result = `$command`;
      say "\n$result" if $result;
      retry($ns) if $?==256 and $should_retry;
   } elsif (not @result) {
      say "Can't find anything matching: [@ARGV].";
      say "Maybe run kget to update the cache.";
   } else {
      print @result; # list matching resources
   }
}

sub retry {
   undef $should_retry;
   my $ns = shift;
   print `$RealBin/get.pl -q pod $ns`;
   find_and_describe();
}
