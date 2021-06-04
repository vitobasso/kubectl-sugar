#!/usr/bin/perl
use v5.12;
use FindBin qw($RealBin);
use lib $RealBin;
use Common::Command qw(run_attach find_do_retry);
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

find_do_retry("pod @ARGV", \&logs, "any pods");

sub logs {
    my ($ns, undef, $pod) = @_;
    my $command = "kubectl -n $ns logs $pod";
    $command = $command . " -c $container" if $container;
    $command = $command . " -f" if $follow;
    run_attach($command);
}
