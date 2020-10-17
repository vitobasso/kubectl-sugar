#!/usr/bin/perl
use v5.12;

say "mkdir -p ~/.scripts-kubectl/resources";
`mkdir -p ~/.scripts-kubectl/resources`;

say "kubectl config get-contexts";
`kubectl config get-contexts | tee ~/.scripts-kubectl/contexts`;

say "kubectl api-resources";
`kubectl api-resources | tee ~/.scripts-kubectl/resource-types`;

say "kubectl get namespaces";
`kubectl get namespaces | tee ~/.scripts-kubectl/namespaces`;

