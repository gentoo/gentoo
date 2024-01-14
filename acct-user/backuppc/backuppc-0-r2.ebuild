# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for app-backup/backuppc"

ACCT_USER_GROUPS=( "backuppc" )
ACCT_USER_HOME="/var/lib/backuppc"
ACCT_USER_ID="282"
ACCT_USER_SHELL="/bin/bash"

acct-user_add_deps
