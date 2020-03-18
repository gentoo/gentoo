# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for net-misc/x2goserver"
ACCT_USER_ID=291
ACCT_USER_GROUPS=( x2gouser )
ACCT_USER_HOME="/var/lib/x2go"

acct-user_add_deps
