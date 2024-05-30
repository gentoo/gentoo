#!/bin/bash
set -e
MMC_DATA_DIR="${XDG_DATA_HOME-"$HOME"/.local/share}/multimc"
exec /usr/lib/multimc/MultiMC -d "$MMC_DATA_DIR" "$@"
