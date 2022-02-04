# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

ACCT_USER_ID=396
ACCT_USER_GROUPS=( greetd video )
DESCRIPTION="User for gui-libs/greetd"

acct-user_add_deps
