# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="Mythtv mythbackend server/deamon user"
ACCT_USER_ID=117
ACCT_USER_GROUPS=( mythtv video audio cdrom tty )
ACCT_USER_SHELL=/bin/bash
ACCT_USER_HOME=/var/lib/mythtv

acct-user_add_deps
