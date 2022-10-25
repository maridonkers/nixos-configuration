#!/bin/sh
#

PERIOD="21d"

nix-collect-garbage --delete-older-than ${PERIOD}
