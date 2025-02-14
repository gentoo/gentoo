# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user eapi9-ver

DESCRIPTION="User for the Syncthing discovery server"
ACCT_USER_ID=497
ACCT_USER_HOME=/var/lib/syncthing-discosrv
ACCT_USER_HOME_PERMS=0770
ACCT_USER_GROUPS=( syncthing )

acct-user_add_deps

pkg_postinst() {
	if ver_replacing -lt 1; then
		ewarn "The home directory of this user has changed to /var/lib/syncthing-discosrv"
		ewarn "If you have any files in /var/lib/${PN}, move them to the new location by hand"
	fi
}
