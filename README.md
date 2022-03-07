A collection of Perl scripts to speed up my day-to-day use of Kubernetes. They work by caching resource names so you can type short commands that won’t change after pod restarts or context switches.

`kctx`  
Shows the current context.

`kctx <search>`  
Sets context to the one matching all the search terms or, if ambiguous, lists matches.

`kget <namespace> <resource-type>`  
Does `kubectl get -n <namespace> <resource-type>` and caches the result for `kexe`, `klog` and `kdes`.

`kexe <search> [-c <container>]`  
Finds a pod then does `kubectl exec -n <namespace> -it <pod> [-c <container>] -- bash`.

`klog <search> [-f] [-c <container>]`  
Finds a pod then does `kubectl logs -n <namespace> <pod> [-f] [-c <container>]`.

`kdes <search>`  
Finds a resource then does `kubectl describe -n <namespace> <resource-type/name>`.

All of `kexe`, `klog` and `kdes` will try to find a namespace and resource, in the local cache only, that matches all search terms.
If multiple matches are found they will just be listed, without running kubectl.
If the kubectl command fails, the cache will be refreshed with `kget`, then kubectl will be retried once.
Search terms can be regex.
