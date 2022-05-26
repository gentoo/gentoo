# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for net-mail/popa3d"
ACCT_USER_ID=375
ACCT_USER_GROUPS=( popa3d )

acct-user_add_deps
