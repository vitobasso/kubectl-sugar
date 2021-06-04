#!/usr/bin/perl
use v5.12;
use FindBin qw($RealBin);
use lib $RealBin;
use Common::File qw(read_file);
use Common::Command qw(run run_cache);
use List::Util qw(all);

my $dir = "$ENV{'HOME'}/.kubesugar-cache";

my @query = @ARGV;
if(@query) {
   my @results = search(@query);
   if(not @results) {
      say "Can't find any context matching: @query";
   } elsif(scalar @results == 1) {
      my $context = shift @results;
      use_context($context);
      init_cache($context);
   } else {
      say join "\n", @results;
   } 
} else {
   print `grep current-context ~/.kube/config`;
}

sub use_context {
   my $name = shift;
   run("kubectl config use-context $name");
}

sub init_cache {
   my $context = shift;
   `mkdir -p ~/.kubesugar-cache/$context`;
   run_cache("kubectl get namespaces", "$context/namespaces") unless -e "$dir/$context/namespaces";
   run_cache("kubectl api-resources", "$context/resource-types") unless -e "$dir/$context/resource-types";
}

sub search {
   my @query = @ARGV;
   my $file = "$dir/contexts";
   map { (split " ", $_)[0] }
      grep { my $line = $_; all { $line =~ /$_/ } @query }
      map { s/^\s+|\s+$//g; $_ } # trim
      map { substr $_, 10 } # remove first column 
      read_file($file);
}

