# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for an open proxy monitor"
ACCT_USER_ID=127
ACCT_USER_GROUPS=( opm )

acct-user_add_deps
