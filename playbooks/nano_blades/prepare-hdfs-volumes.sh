#!/usr/bin/env bash

function run {
    "$@"
    local status=$?
    if [ $status -ne 0 ]; then
        echo "error with $1. Exit status $status is not equal 0" >&2
        exit 1
    fi
    return $status
}

for i in {1..2}
do
    volume_name=hdfs_volume_$i
    run mkdir /$volume_name
    run dd if=/dev/zero of=/fcpir_fast_vol/$volume_name.ext3 count=734003200 # 350 GB, block size 512b
    run /sbin/mkfs -t ext3 -q /fcpir_fast_vol/$volume_name.ext3 -F
    run echo "/fcpir_fast_vol/$volume_name.ext3    /$volume_name ext3    rw,loop,usrquota,grpquota  0 0" >> /etc/fstab
	run mount /hdfs_volume_$i
	run chown -R nano /hdfs_volume_$i
	run chmod -R 700 /hdfs_volume_$i
done
