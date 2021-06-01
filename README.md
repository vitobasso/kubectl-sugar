A collection of perl scripts to help me type less kubectl commands.

`kctx`  
Shows the current context.

`kctx <search>`  
Sets context to the one matching all the search terms or, if ambiguous, lists matches.

`kget <namespace> <resource-type>`  
Does `kubectl get -n <namespace> <resource-type>` and caches the result for `kexe`, `klog` and `kdes`.

`kexe <search>`  
Finds a pod then does `kubectl exec -n <namespace> -it <pod> -- bash`.

`klog <search>`  
Finds a pod then does `kubectl logs -n <namespace> <pod>`.

`kdes <search>`  
Finds a resource then does `kubectl describe -n <namespace> <resource-type/name>`.

All of `kexe`, `klog` and `kdes` will try to find a namespace and resource, in the local cache only, that matches all search terms.
If multiple matches are found they will just be listed, without running kubectl.
If the kubectl command fails, the cache will be refreshed with `kget`, then kubectl will be retried once.
Search terms can be regex.
