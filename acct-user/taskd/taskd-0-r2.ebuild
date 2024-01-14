# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for app-misc/taskd"

ACCT_USER_GROUPS=( "taskd" )
ACCT_USER_HOME="/var/lib/taskd"
ACCT_USER_ID="152"
ACCT_USER_SHELL="/bin/bash"

acct-user_add_deps
