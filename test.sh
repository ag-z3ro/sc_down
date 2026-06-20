#!/bin/bash

Ubuntu 22.04.5 Post Install Script v0.1

set -e

LOGFILE="/var/log/postinstall.log"

exec > >(tee -a "$LOGFILE")
exec 2>&1

if [[ $EUID -ne 0 ]]; then
echo "Bitte als root oder mit sudo starten."
exit 1
fi
