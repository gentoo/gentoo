# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for net-im/ejabberd"

ACCT_USER_ID=114
ACCT_USER_GROUPS=( ${PN} )
ACCT_USER_HOME=/var/lib/${PN}

IUSE="pam"

RDEPEND="pam? ( acct-group/epam )"

acct-user_add_deps

pkg_setup() {
	use pam && ACCT_USER_GROUPS+=( epam )
}
