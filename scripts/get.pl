#!/usr/bin/perl
use v5.12;
use FindBin qw($RealBin);
use Getopt::Long qw(GetOptions);

sub help {
   say "Usage: \tkget <namespace> <resource>";
   say "";
   say "Options:";
   say "\t--quiet, -q\t Don't print the output from kubectl, only the kubectl command executed.";
}

my $quiet;
GetOptions('quiet|q' => \$quiet) or help and exit;

my $context = get_context() or say "Context not set." and exit;
my $dir = "$ENV{'HOME'}/.kubesugar-cache/$context";
`mkdir -p $dir/resources`;

my ($arg1, $arg2) = (@ARGV);
my $namespace = (find_namespace($arg1) or find_namespace($arg2));
my $resource = (find_resource($arg1) or find_resource($arg2));

if($namespace and $resource) {
   my $cache = "$dir/resources/$namespace-$resource";
   say "kubectl get $resource -n $namespace > $cache";
   my $output = `kubectl get $resource -n $namespace`;
   write_file($output, $cache) if $output;
   print "\n$output" unless $quiet;
} else {
   say "\"$namespace\" seems to be a namespace but we're missing a resource type." if $namespace;
   say "\"$resource\" seems to be a resource type but we're missing a namespace." if $resource;
   say "";
   help;
}

sub find_namespace {
   my $string = shift;
   my @found = grep { /^$string$/ } 
                map { (split /\s+/)[0] } 
                read_file("$dir/namespaces");
   shift @found;
}

sub find_resource {
   my $string = shift;
   my @types = read_file("$dir/resource-types");
   my @found_names = grep { /^${string}s?$/ } map { (split /\s+/)[0] } @types;
   my @found_mnemonics = grep { /^${string}$/ } map { (split /\s+/)[1] } @types;
   shift @found_names || shift @found_mnemonics;
}

sub get_context {
   $1 if `$RealBin/context.pl` =~ /.*: (.*)/
}

sub read_file {
   open(FILE, '<', shift) or die $!;
   chomp(my @lines = <FILE>);
   close FILE;
   splice @lines, 1;
}

sub write_file {
    my $data = shift;
    my $filename = shift;
    open(FH, '>', $filename) or die $!;
    print FH $data;
    close(FH);
}