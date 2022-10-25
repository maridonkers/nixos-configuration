#!/bin/sh

BOOTED="$(readlink /run/booted-system/{initrd,kernel,kernel-modules})"
UPDATED="$(readlink /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules})"

echo "BOOTED: ${BOOTED}"
echo "UPGRADED:${UPDATED}"

echo ""
if [ "${BOOTED}" != "${UPDATED}" ]
then
  echo "REBOOT REQUIRED";
else
  echo "NO ACTION NECESSARY";
fi
