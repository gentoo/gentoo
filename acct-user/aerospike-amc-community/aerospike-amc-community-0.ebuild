# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="Aerospike-amc-community acct-group"
ACCT_USER_ID=134

ACCT_USER_GROUPS=( ${PN} )

acct-user_add_deps
