# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for gpsd"
ACCT_USER_ID=299
ACCT_USER_GROUPS=( dialout )

acct-user_add_deps
