#!/usr/bin/perl
use v5.12;
use FindBin qw($RealBin);
use Expect;

sub help {
   say "Usage: klog <pod search terms>";
   say "Examples";
   say "\tklog dap wep-mask";
   say "\tklog mask";
}

help and exit unless @ARGV;

my $should_retry = "once";
find_and_exec();

sub find_and_exec {
   my @result = `$RealBin/kubectl-find.pl pod @ARGV`;
   if(scalar @result == 1) {
      my ($ns, $res, $pod) = split " ", shift @result;
      my $command = "kubectl -n $ns logs $pod";
      say $command;
      say "";
      say `$command`;
      retry($ns) if $?==256 and $should_retry;      
   } elsif (not @result) {
      say "Can't find any pods matching: @ARGV";
   } else {
      print @result; # list matching pods
   }
}
   
sub retry {
   undef $should_retry;
   my $ns = shift;
   print `$RealBin/kubectl-get.pl -q pod $ns`;
   find_and_exec();
}
