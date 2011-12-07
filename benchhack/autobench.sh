#!/bin/sh

cd /mnt/ssd

while [ 1 -eq 1 ];
do
	date
	/root/diskbench.sh run
	sync
	echo 3 > /proc/sys/vm/drop_caches
	sleep 300
done
