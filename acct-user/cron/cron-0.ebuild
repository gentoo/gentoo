# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for sys-process/cronbase"

ACCT_USER_GROUPS=( "cron" )
ACCT_USER_HOME="/var/spool/cron"
ACCT_USER_ID="16"

acct-user_add_deps
