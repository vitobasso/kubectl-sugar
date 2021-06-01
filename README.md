A collection of perl scripts to help me type less kubectl commands.

`kctx`  
Shows the current context.

`kctx <search>`  
Sets context to the one matching all the search terms or, if ambiguous, lists matches.

`kget <namespace> <resource-type>`  
Does `kubectl get -n <namespace> <resource-type>` and caches the result for `kexe`, `klog` and `kdesc`.

`kexe <search>`  
Finds a pod then does `kubectl exec -n <namespace> -it <pod> bash`.

`klog <search>`  
Finds a pod then does `kubectl logs -n <namespace> <pod>`.

`kdesc <search>`  
Finds a resource then does `kubectl describe -n <namespace> <resource-type/name>`.

All of `kexe`, `klog` and `kdesc` will try to find a namespace and resource in the local cache only, based on the search terms.
If multiple resources are found they will just be listed, without running kubectl.
If the kubectl command fails, they will refresh the cache with `kget` and then retry once.
Search terms can be regex.