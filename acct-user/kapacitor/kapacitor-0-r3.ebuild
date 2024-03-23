# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for kapacitor"
ACCT_USER_ID=343
ACCT_USER_GROUPS=( kapacitor )
ACCT_USER_HOME=/var/lib/kapacitor

acct-user_add_deps
