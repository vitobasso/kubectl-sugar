#!/usr/bin/perl
use v5.12;

sub help {
   say "Usage: \tkget <namespace> <resource>";
   say "";
   say "Examples:";
   say "\tkget dap pods";
   say "\tkget pod dap";
}

my ($arg1, $arg2) = (@ARGV);
my $namespace = (find_namespace($arg1) or find_namespace($arg2));
my $resource = (find_resource($arg1) or find_resource($arg2));

if($namespace and $resource) {
   say "kubectl get $resource -n $namespace";
   `kubectl get $resource -n $namespace | awk 'NR\>1 {print \$1}' | tee ~/.scripts-kubectl/resources/$namespace-$resource`;
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
   my $name = shift;
   open(FILE, '<', $name) or die "Failed to read file: [$name]. $!";
   chomp(my @lines = <FILE>);
   close FILE;
   @lines;
}
