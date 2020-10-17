#!/usr/bin/perl
use v5.12;
use List::Util qw(all);

sub help {
   say "Usage: \tkfind <search terms>";
   say "";
   say "Examples:";
   say "\tkfind pod lap-dog dap";
   say "\tkfind pod dap dog";
   say "\tkfind dog";
}

my @search = @ARGV or help and exit;
my $dir = "$ENV{'HOME'}/.scripts-kubectl/resources";
my @filenames = list_files($dir);

foreach my $file (sort @filenames){
   foreach my $line (read_file("$dir/$file")){
      if(all { "$file $line" =~ /$_/ } @search){
         my ($ns, $res) = split "-", $file; 
         say "$ns $res $line";
      }
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
   @lines;
}
