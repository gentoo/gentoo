# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for mythbackend server/deamon"
ACCT_USER_ID=117
ACCT_USER_GROUPS=( mythtv )
ACCT_USER_GROUPS=( video audio tty uucp )

acct-user_add_deps
