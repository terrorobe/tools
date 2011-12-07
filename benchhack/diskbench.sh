#!/bin/sh


THREADS=1
GB=6
MODE=seqrd
RUNTIME=30 #seconds
MAXREQ=0
IOSIZE=32K
OPTIONS="--test=fileio --num-threads=$THREADS --file-block-size=$IOSIZE --file-test-mode=$MODE --file-num=$GB --file-total-size=${GB}G --file-fsync-freq=0 --file-fsync-end=no"

echo $1

if [ "$1" = "run" ]; then
OPTIONS="$OPTIONS --max-time=$RUNTIME --max-requests=$MAXREQ"
fi

CMD="sysbench $1 $OPTIONS"

echo "Running $CMD"
$CMD
