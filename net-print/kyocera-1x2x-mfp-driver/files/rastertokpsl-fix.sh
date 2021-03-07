#!/bin/bash
# This file is a slightly modified version of 'rastertokpsl_wrapper' script
# by Maxim Norin. See https://github.com/mnorin/kyocera-ppd-installer for
# the original version.
# Distributed under the terms of the GNU General Public License v2.
jobname="$(echo "$3" | grep -Eo "[[:alnum:]]" | tr -d "\n" | tail -c 20)"
/usr/libexec/cups/filter/rastertokpsl "$1" "$2" "${jobname}" "$4" "$5"
