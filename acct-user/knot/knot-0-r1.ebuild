# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for knot DNS server"
ACCT_USER_ID=53
ACCT_USER_HOME=/var/lib/knot
ACCT_USER_GROUPS=( knot )

acct-user_add_deps
