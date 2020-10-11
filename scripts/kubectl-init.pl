#!/usr/bin/perl
use v5.12;

say "mkdir -p ~/.scripts-kubectl/resources";
`mkdir -p ~/.scripts-kubectl/resources`;

say "kubectl config get-contexts";
`kubectl config get-contexts | cut -c 11- | awk 'NR\>1 {print \$1 " " \$2}' | tee ~/.scripts-kubectl/contexts`;

say "kubectl api-resources";
`kubectl api-resources | awk 'NR\>1 {print \$1}' | tee ~/.scripts-kubectl/resource-types`;

say "kubectl get namespaces";
`kubectl get namespaces | awk 'NR\>1 {print \$1}' | tee ~/.scripts-kubectl/namespaces`;

