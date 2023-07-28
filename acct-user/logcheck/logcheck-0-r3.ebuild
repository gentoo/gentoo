# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for app-admin/logcheck"
IUSE="systemd"

ACCT_USER_GROUPS=( "logcheck" )
ACCT_USER_ID="284"

RDEPEND="systemd? ( acct-group/systemd-journal )"

acct-user_add_deps

pkg_setup() {
	# Allow the 'logcheck' user to view the systemd journal.
	if use systemd; then
		ACCT_USER_GROUPS+=( systemd-journal )
	fi
}
