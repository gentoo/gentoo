#!/bin/sh

# Greenbone Vulnerability Manager Systemd ExecStartPre
mkdir -p /run/gvmd
touch /run/gvmd/gvm-{checking,create-functions,helping,migrating,serving}
chown -R gvm:gvm /run/gvmd/
touch /run/feed-update.lock
chown gvm:gvm /run/feed-update.lock
