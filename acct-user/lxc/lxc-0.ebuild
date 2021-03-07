# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for app-emulation/lxc"
ACCT_USER_ID=358
ACCT_USER_GROUPS=( lxc )

acct-user_add_deps
