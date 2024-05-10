#!/bin/sh
#
# https://btrfs.readthedocs.io/en/latest/btrfs-balance.html
#

if [ $# -lt 1 ]
then
	echo "Usage: $0 <musage>";
	exit 1;
fi

btrfs balance start -musage=$1 /home
