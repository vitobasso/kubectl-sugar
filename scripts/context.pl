#!/usr/bin/perl
use v5.12;
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
   my $command = "kubectl config use-context $name";
   say $command;
   `$command`;
}

sub init_cache {
   my $context = shift;
   `mkdir -p ~/.kubesugar-cache/$context`;
   
   my $namespaces_file = "$dir/$context/namespaces";
   if (not -e $namespaces_file) {
       my $namespaces_command = "kubectl get namespaces > $namespaces_file";
       say $namespaces_command;
       `$namespaces_command`;
   }
   
   my $resources_file = "$dir/$context/resource-types";
   if (not -e $resources_file) {
       my $resources_command = "kubectl api-resources > $resources_file";
       say $resources_command;
       `$resources_command`;
   }
}

sub search {
   my @query = @ARGV;
   my $file = "$dir/contexts";
   map { (split " ", $_)[0] }
      grep { my $line = $_; all { $line =~ /$_/ } @query }
      map { s/^\s+|\s+$//g; $_ } # trim
      read_file($file);
}

sub read_file {
   open(FILE, '<', shift) or die $!;
   chomp(my @lines = <FILE>);
   close FILE;
   my @names = map { substr $_, 10 }  @lines;
   splice @names, 1;
}
