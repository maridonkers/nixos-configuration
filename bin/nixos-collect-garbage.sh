#!/bin/sh
#

PERIOD="7d"

nix-collect-garbage --delete-older-than ${PERIOD}
