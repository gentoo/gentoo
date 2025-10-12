# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

ACCT_USER_ID=396
ACCT_USER_GROUPS=( greetd video )
ACCT_USER_HOME="/var/lib/greetd"
DESCRIPTION="User for gui-libs/greetd"

acct-user_add_deps
