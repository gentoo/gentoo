# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for www-misc/vdradmin-am"

ACCT_USER_ID=453
ACCT_USER_GROUPS=( vdradmin )

acct-user_add_deps

DEPEND+=" acct-group/vdradmin "
RDEPEND+=" acct-group/vdradmin "
