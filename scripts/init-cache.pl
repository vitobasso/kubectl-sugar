#!/usr/bin/perl
use v5.12;
use FindBin qw($RealBin);
use lib $RealBin;
use Common::Context qw(get_context);
use Common::Command qw(run_cache);

say "mkdir -p ~/.kubesugar-cache";
`mkdir -p ~/.kubesugar-cache`;

run_cache("kubectl config get-contexts", "$ENV{'HOME'}/.kubesugar-cache/contexts");

my $context = get_context();
system("$RealBin/context.pl $context") if $context;
