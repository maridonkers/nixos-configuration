#!/bin/sh
#
# https://discourse.nixos.org/t/beginner-questions-reboot-documentation-and-own-scripts/3282/2
#

ls -l /run/{booted,current}-system/kernel*
echo ""
echo "(Check if the symlinks are different.)"
