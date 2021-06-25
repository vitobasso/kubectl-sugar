#!/usr/bin/perl
use v5.12;
use FindBin qw($RealBin);
use lib $RealBin;
use Common::File qw(read_file list_files);
use Common::Context qw(get_context);
use List::Util qw(all);

sub help {
   say "Usage: \tkfind <search terms>";
   say "";
   say "Examples:";
   say "\tkfind pod my-cool-app namespace";
   say "\tkfind pod namespace app";
   say "\tkfind app";
}

my @search = @ARGV or help and exit;
my $context = get_context() or say STDERR "Context not set." and exit;
my $cache = "$ENV{'HOME'}/.kubesugar-cache/$context/resources";
`mkdir -p $cache`;
my @filenames = list_files($cache);

foreach my $file (sort @filenames){
   my @lines = map { (split /\s+/)[0] } read_file("$cache/$file");
   foreach my $line (@lines){
      if(all { "$file $line" =~ /$_/ } @search){
         my ($ns, $res) = split "-", $file; 
         say "$ns $res $line";
      }
   }
}
