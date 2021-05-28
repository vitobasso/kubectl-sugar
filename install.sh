TARGET=/usr/local/bin
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo Creating links under $TARGET
ln -s $DIR/scripts/kubectl-context.pl $TARGET/kctx
ln -s $DIR/scripts/kubectl-describe.pl $TARGET/kdesc
ln -s $DIR/scripts/kubectl-exec.pl $TARGET/kexe
ln -s $DIR/scripts/kubectl-find.pl $TARGET/kfind
ln -s $DIR/scripts/kubectl-get.pl $TARGET/kget
ln -s $DIR/scripts/kubectl-logs.pl $TARGET/klog
echo

echo Initializing the cache ...
$DIR/scripts/kubectl-init.pl
