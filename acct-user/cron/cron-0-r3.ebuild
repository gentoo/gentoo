# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for sys-process/cronbase"

ACCT_USER_GROUPS=( "cron" )
ACCT_USER_HOME="/var/spool/cron"
ACCT_USER_ID="16"
ACCT_USER_HOME_OWNER="root:cron"
ACCT_USER_HOME_PERMS="0750"

acct-user_add_deps
