# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

ACCT_USER_ID=66
ACCT_USER_GROUPS=( "maradns" )

acct-user_add_deps

DEPEND+=" acct-group/maradns "
RDEPEND+=" acct-group/maradns "
