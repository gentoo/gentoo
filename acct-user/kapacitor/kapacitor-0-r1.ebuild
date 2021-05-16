# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for kapacitor"
ACCT_USER_ID=343
ACCT_USER_GROUPS=( kapacitor )
ACCT_USER_HOME=/var/lib/kapacitor

acct-user_add_deps
