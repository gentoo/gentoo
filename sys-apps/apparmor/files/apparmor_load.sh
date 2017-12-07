#!/bin/sh
find "/etc/apparmor.d/" -maxdepth 1 -type f -exec apparmor_parser -r {} +
