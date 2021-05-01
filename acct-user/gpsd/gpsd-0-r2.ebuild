# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for gpsd"
ACCT_USER_ID=299
# bug #744982
ACCT_USER_GROUPS=( dialout uucp )

acct-user_add_deps
