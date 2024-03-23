# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="user for munin"

ACCT_USER_GROUPS=( munin )
ACCT_USER_HOME="/var/lib/munin"
ACCT_USER_ID=177

acct-user_add_deps
