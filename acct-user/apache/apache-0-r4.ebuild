# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

ACCT_USER_ID="81"
ACCT_USER_GROUPS=( "apache" )
ACCT_USER_HOME="/var/www"

IUSE="icinga"

acct-user_add_deps

RDEPEND+="
	icinga? (
		acct-group/icingacmd
		acct-group/icingaweb2
	)
"

pkg_setup() {
	# www-apps/icingaweb2
	use icinga && ACCT_USER_GROUPS+=( icingacmd icingaweb2 )
}
