#!/bin/sh
#

PERIOD="3d"

nix-collect-garbage --delete-older-than ${PERIOD}
