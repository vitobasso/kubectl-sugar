TARGET=/usr/local/bin
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "To uninstall please run these commands after making sure you don't happen to have something else with the same names:"
echo
echo "rm $TARGET/{kctx,kdesc,kexe,kfind,kget,klog}"
echo "rm -r ~/.kubesugar-cache"
