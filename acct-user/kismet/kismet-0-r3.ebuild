# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="net-wireless/kismet"
ACCT_USER_ID="388"
ACCT_USER_GROUPS=( kismet )

acct-user_add_deps

DEPEND+=" acct-group/kismet "
RDEPEND+=" acct-group/kismet "
