#!/usr/bin/perl
use v5.12;
use FindBin qw($RealBin);
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

my $should_retry = "once";
find_and_exec();

sub find_and_exec {
   my @result = `$RealBin/kubectl-find.pl pod @ARGV`;
   if(scalar @result == 1) {
      my ($ns, $res, $pod) = split " ", shift @result;
      my $command = "kubectl -n $ns exec -it $pod -- bash";
      if($container) {
        $command = $command . " -c $container";
      }
      say $command;
      my $session = Expect->spawn($command);
      $session->slave->clone_winsize_from(\*STDIN);
      $session->interact();
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
