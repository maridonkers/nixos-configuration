#!/bin/sh
#
# https://nixos.wiki/wiki/Nix_channels
#

if [ $# -lt 1 ]
then
	echo "Usage: $0 <package>";
	exit 1;
fi

#hydra-check --channel unstable bash
hydra-check --channel unstable $1
