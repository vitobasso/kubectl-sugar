package Common::Context;

use v5.12;
use FindBin qw($RealBin);

use Exporter qw(import);
our @EXPORT_OK = qw( get_context );

sub get_context {
   $1 if `$RealBin/context.pl` =~ /.*: (.*)/
}

1;