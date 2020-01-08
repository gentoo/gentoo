# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for asterisk"
ACCT_USER_ID=242
ACCT_USER_GROUPS=( asterisk dialout )

acct-user_add_deps
