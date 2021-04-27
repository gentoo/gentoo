# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for ldap"
ACCT_USER_ID=439
ACCT_USER_GROUPS=( ldap )

acct-user_add_deps

pkg_setup() {
	ACCT_USER_HOME=/usr/$(get_libdir)/openldap
}
