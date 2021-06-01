TARGET=/usr/local/bin
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo Creating links under $TARGET
ln -s $DIR/scripts/context.pl $TARGET/kctx
ln -s $DIR/scripts/describe.pl $TARGET/kdes
ln -s $DIR/scripts/exec.pl $TARGET/kexe
ln -s $DIR/scripts/find.pl $TARGET/kfind
ln -s $DIR/scripts/get.pl $TARGET/kget
ln -s $DIR/scripts/logs.pl $TARGET/klog
echo

echo Initializing the cache ...
$DIR/scripts/init-cache.pl
