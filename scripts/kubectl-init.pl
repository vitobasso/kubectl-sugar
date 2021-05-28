#!/usr/bin/perl
use v5.12;

say "mkdir -p ~/.kubesugar-cache/resources";
`mkdir -p ~/.kubesugar-cache/resources`;

say "kubectl config get-contexts";
`kubectl config get-contexts | tee ~/.kubesugar-cache/contexts`;

say "kubectl api-resources";
`kubectl api-resources | tee ~/.kubesugar-cache/resource-types`;

say "kubectl get namespaces";
`kubectl get namespaces | tee ~/.kubesugar-cache/namespaces`;

