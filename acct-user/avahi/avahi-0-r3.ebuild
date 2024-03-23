# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="user for avahi"
ACCT_USER_ID=61
ACCT_USER_GROUPS=( avahi )

acct-user_add_deps
