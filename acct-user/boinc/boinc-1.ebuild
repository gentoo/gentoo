# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for sci-misc/boinc"
ACCT_USER_ID=352
ACCT_USER_HOME=/var/lib/${PN}
ACCT_USER_HOME_PERMS=0750
ACCT_USER_GROUPS=( boinc docker video )

acct-user_add_deps

pkg_postinst() {
	acct-user_pkg_postinst

	elog "To run Docker application via Podman, BOINC needs to be granted permissions:"
	elog "# usermod --add-subuids 1065536-1131071 boinc"
	elog "# usermod --add-subgids 1065536-1131071 boinc"
}
