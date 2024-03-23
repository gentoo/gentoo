# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="user for munin async proxy node"

ACCT_USER_GROUPS=( munin )
ACCT_USER_HOME="/var/spool/munin-async"
ACCT_USER_ID=178
ACCT_USER_SHELL=/bin/sh

acct-user_add_deps
