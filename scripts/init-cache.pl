#!/usr/bin/perl
use v5.12;
use FindBin qw($RealBin);

say "mkdir -p ~/.kubesugar-cache";
`mkdir -p ~/.kubesugar-cache`;

my $contexts_command = "kubectl config get-contexts > $ENV{'HOME'}/.kubesugar-cache/contexts";
say $contexts_command;
`$contexts_command`;

my $context = get_context();
system("$RealBin/context.pl $context") if $context;

sub get_context {
    $1 if `$RealBin/context.pl` =~ /.*: (.*)/
}
