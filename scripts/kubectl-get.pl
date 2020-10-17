#!/usr/bin/perl
use v5.12;
use Getopt::Long qw(GetOptions);


sub help {
   say "Usage: \tkget <namespace> <resource>";
   say "";
   say "Examples:";
   say "\tkget dap pods";
   say "\tkget pod dap";
   say "";
   say "Options:";
   say "\t--quiet, -q\t Don't print the output from kubectl, only the kubectl command executed.";
}

my $quiet;
GetOptions('quiet|q' => \$quiet) or help and exit;

my ($arg1, $arg2) = (@ARGV);
my $namespace = (find_namespace($arg1) or find_namespace($arg2));
my $resource = (find_resource($arg1) or find_resource($arg2));

if($namespace and $resource) {
   say "kubectl get $resource -n $namespace";
   my $output = `kubectl get $resource -n $namespace | tee ~/.scripts-kubectl/resources/$namespace-$resource`;
   print "\n$output" unless $quiet;
} else {
   say "\"$namespace\" seems to be a namespace but we're missing a resource type." if $namespace;
   say "\"$resource\" seems to be a resource type but we're missing a namespace." if $resource;
   say "";
   help;
}

sub find_namespace {
   my $string=shift;
   my @found = grep { /^$string$/ } read_file("$ENV{'HOME'}/.scripts-kubectl/namespaces");
   shift @found;
}

sub find_resource {
   my $string=shift;
   my @found = grep { /^${string}s?$/ } read_file("$ENV{'HOME'}/.scripts-kubectl/resource-types");
   shift @found;
}

sub read_file {
   open(FILE, '<', shift) or die $!;
   chomp(my @lines = <FILE>);
   close FILE;
   my @names = map { (split /\s+/)[0] } @lines;
   splice @names, 1;
}
