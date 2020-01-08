# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for cmd5checkpw"
ACCT_USER_ID=212
ACCT_USER_GROUPS=( nofiles )

acct-user_add_deps
