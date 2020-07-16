# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for munin"

ACCT_USER_GROUPS=( munin )
ACCT_USER_HOME="/var/lib/munin"
ACCT_USER_HOME_OWNER="munin:munin"
ACCT_USER_ID=177

acct-user_add_deps
