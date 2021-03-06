#!/usr/bin/perl
use v5.12;
use FindBin qw($RealBin);
use lib $RealBin;
use Common::File qw(read_file);
use Common::Context qw(get_context);
use Common::Command qw(run_cache);
use Getopt::Long qw(GetOptions);

sub help {
   say "Usage: \tkget <namespace> <resource>";
   say "";
   say "Options:";
   say "\t--quiet, -q\t Don't print the output from kubectl, only the kubectl command executed.";
}

my $quiet;
GetOptions('quiet|q' => \$quiet) or help and exit;

my $context = get_context() or say STDERR "Context not set." and exit;
my $cache = "$ENV{'HOME'}/.kubesugar-cache/$context";

my ($arg1, $arg2) = (@ARGV);
my $namespace = (find_namespace($arg1) or find_namespace($arg2));
my $resource = (find_resource($arg1) or find_resource($arg2));

if($namespace and $resource) {
   `mkdir -p $cache/resources`;
   my $output = run_cache("kubectl get $resource -n $namespace", "$context/resources/$namespace-$resource");
   print "\n$output" unless $quiet;
} else {
   say STDERR "\"$namespace\" seems to be a namespace but we're missing a resource type." if $namespace;
   say STDERR "\"$resource\" seems to be a resource type but we're missing a namespace." if $resource;
   say STDERR "";
   help;
}

sub find_namespace {
   my $string = shift;
   my @found = grep { /^$string$/ } 
                map { (split /\s+/)[0] }
                read_file("$cache/namespaces");
   shift @found;
}

sub find_resource {
   my $string = shift;
   my @types = read_file("$cache/resource-types");
   my @found_names = grep { /^${string}s?$/ } map { (split /\s+/)[0] } @types;
   my @found_mnemonics = grep { /^${string}$/ } map { (split /\s+/)[1] } @types;
   shift @found_names || shift @found_mnemonics;
}
