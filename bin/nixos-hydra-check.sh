#!/bin/sh
#
# https://nixos.wiki/wiki/Nix_channels
#

if [ $# -lt 2 ]
then
	echo "Usage: $0 <channel> <package>";
	echo ""
	echo "e.g. $0 23.11 chromium"
	exit 1;
fi

#hydra-check --channel unstable bash
hydra-check --channel $1 $2
