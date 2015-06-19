#!/sbin/runscript
# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/cancd/files/cancd-conf.d,v 1.1 2005/11/14 21:15:54 robbat2 Exp $

# user to run as, root strongly discouraged
# user should have /bin/false for a shell
# but file access into /var
CHUID='adm:nobody'

# port to listen on
CANCD_PORT=6667

# directory to output to
CRASH_DIR=/var/crash

# one file per minute, one dir per host/date
#CRASH_FORMAT="%Q/%Y-%m-%d/%H:%M.log"
# one file per day, one dir per host
CRASH_FORMAT="%Q/%Y-%m-%d.log"
