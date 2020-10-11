A colleciton of perl scripts to help me type less kubectl commands.


`kinit`  
Gets the list of contexts, namespaces and resource types and caches under `~/.scripts-kubectl/` for the following commands.

`kctx`  
Shows the current context.

`kctx <search>`  
Sets context to the one matching all the search words or, if ambiguous, lists matches. Search words can be regex.

`kget <namespace> <resource-type>`  
Does `kubectl get -n <namespace> <resource-type>` and caches the result for the next commands.

`kexe <search>`  
Finds a matching pod and namespace then does `kubectl exec -n <namespace> -it <pod> bash` or, if ambiguous, lists matches. If it fails, refreshes `kget` and retries.

`klog <search>`  
Finds a pod then does `kubectl logs -n <namespace> <pod>`.

`kdesc <search>`  
Finds a resource then does `kubectl describe -n <namespace> <resource-type/name>`.

