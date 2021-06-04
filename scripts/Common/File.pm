package Common::File;

use v5.12;
use FindBin qw($RealBin);

use Exporter qw(import);
our @EXPORT_OK = qw( read_file write_file list_files );

sub read_file {
   open(FILE, '<', shift) or die $!;
   chomp(my @lines = <FILE>);
   close FILE;
   splice @lines, 1; # remove header
}

sub write_file {
    my $data = shift;
    my $filename = shift;
    open(FH, '>', $filename) or die $!;
    print FH $data;
    close(FH);
}

sub list_files {
   opendir(DIR, shift) or die $!;
   my @files = readdir DIR;
   close DIR;
   @files;
}

1;