#! /bin/sh
OUTDIR=js/server
SRCDIR=src/server
rm -rf $OUTDIR/* 
coffee -o $OUTDIR/ -c $SRCDIR/ 
cp $SRCDIR/routes/index.html $OUTDIR/routes
find $OUTDIR/ -type f -exec sed -i "s/\.coffee'/'/g" {} +
