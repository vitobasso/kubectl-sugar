#!/usr/bin/perl
use v5.12;
use List::Util qw(all);

my @query = @ARGV;
if(@query) {
   my @results = search(@query);
   if(not @results) {
      say "Can't find any context matching: @query";
   } elsif(scalar @results == 1) {
      use_context(shift @results);
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

sub search {
   my @query = @ARGV;
   my $file = "$ENV{'HOME'}/.scripts-kubectl/contexts";
   map { (split " ", $_)[0] } 
      grep { my $line = $_; all { $line =~ /$_/ } @query } 
      read_file($file);
}

sub read_file {
   open(FILE, '<', shift) or die $!;
   chomp(my @lines = <FILE>);
   close FILE;
   my @names = map { my @cols = split /\s+/; "@cols[0] @cols[1]" } 
               map { substr $_, 10 }  @lines;
   splice @names, 1;
}
