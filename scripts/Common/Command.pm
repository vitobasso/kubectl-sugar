package Common::Command;

use v5.12;
use FindBin qw($RealBin);
use lib $RealBin;
use Common::File qw(write_file);
use Term::ANSIColor;

use Exporter qw(import);
our @EXPORT_OK = qw( run run_cache run_attach find_do_retry );

sub run {
    my $command = shift;
    
    print color('bold');
    say $command;
    print color('reset');
    
    `$command`;
}

sub run_cache {
    my ($command, $cache) = @_;
    
    print color('bold');
    print "$command";
    print color('reset grey8');
    print " > ~/.kubesugar-cache/$cache\n";
    print color('reset');
    
    my $output = `$command`;
    write_file($output, "$ENV{'HOME'}/.kubesugar-cache/$cache") if $output;
    $output
}

sub run_attach {
    my $command = shift;
    
    print color('bold');
    say $command;
    print color('reset');
    
    my $session = Expect->spawn($command);
    $session->slave->clone_winsize_from(\*STDIN);
    $session->interact();
}

sub find_do_retry {
    my ($find_args, $callback, $thing_missing) = @_;
    
    my $should_retry = "once";
    try();
    
    sub try {
       my @result = `$RealBin/find.pl $find_args`;
       if(scalar @result == 1) {
          my ($ns, $type, $name) = split " ", shift @result;
          $callback->($ns, $type, $name);
          retry($ns) if $?==256 and $should_retry;      
       } elsif (not @result) {
          say "Can't find $thing_missing matching: [@ARGV].";
          say "Maybe run " . color("bold") . "kget" . color('reset') . " to update the cache.";
       } else {
          print @result; # list matching resources
       }
    }
       
    sub retry {
       undef $should_retry;
       my $ns = shift;
       print `$RealBin/get.pl -q pod $ns`;
       try();
    }
}

1;