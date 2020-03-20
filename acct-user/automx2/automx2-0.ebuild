# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for net-mail/automx2"

ACCT_USER_ID=437
ACCT_USER_GROUPS=( automx2 )
ACCT_USER_HOME="/var/lib/automx2"

acct-user_add_deps
