#!/usr/bin/perl
use v5.12;
use FindBin qw($RealBin);
use Getopt::Long qw(GetOptions);
use Expect;

sub help {
   say "Usage: klog <pod search terms> [-c container] [-f]";
   say "";
   say "Examples:";
   say "\tklog namespace my-cool-app";
   say "\tklog app";
}

help and exit unless @ARGV;

my $container;
my $follow;
GetOptions('container|c=s' => \$container, 'follow|f' => \$follow) or help and exit;

my $should_retry = "once";
find_and_log();

sub find_and_log {
   my @result = `$RealBin/kubectl-find.pl pod @ARGV`;
   if(scalar @result == 1) {
      my ($ns, $res, $pod) = split " ", shift @result;
      my $command = "kubectl -n $ns logs $pod";
      if($container) {
        $command = $command . " -c $container";
      }
      if($follow) {
        $command = $command . " -f";
      }
      say $command;
      say "";
      my $session = Expect->spawn($command);
      $session->slave->clone_winsize_from(\*STDIN);
      $session->interact();
      retry($ns) if $?==256 and $should_retry;      
   } elsif (not @result) {
      say "Can't find any pods matching: [@ARGV].";
      say "Maybe run kget to update the cache.";
   } else {
      print @result; # list matching pods
   }
}
   
sub retry {
   undef $should_retry;
   my $ns = shift;
   print `$RealBin/kubectl-get.pl -q pod $ns`;
   find_and_log();
}
