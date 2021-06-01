#!/usr/bin/perl
use v5.12;
use FindBin qw($RealBin);
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
my $context = get_context() or say "Context not set." and exit;
my $dir = "$ENV{'HOME'}/.kubesugar-cache/resources/$context";
`mkdir -p $dir`;
my @filenames = list_files($dir);

foreach my $file (sort @filenames){
   foreach my $line (read_file("$dir/$file")){
      if(all { "$file $line" =~ /$_/ } @search){
         my ($ns, $res) = split "-", $file; 
         say "$ns $res $line";
      }
   }
}

sub get_context {
    if(`$RealBin/kubectl-context.pl` =~ /.*: (.*)/) {
        $1;
    }
}

sub list_files {
   opendir(DIR, shift) or die $!;
   my @files = readdir DIR;
   close DIR;
   @files;
}

sub read_file {
   open(FILE, '<', shift) or die $!;
   chomp(my @lines = <FILE>);
   close FILE; 
   my @names = map { (split /\s+/)[0] } @lines;
   splice @names, 1;
}

