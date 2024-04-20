# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for the Syncthing discovery server"
ACCT_USER_ID=497
ACCT_USER_HOME=/var/lib/syncthing-discosrv
ACCT_USER_HOME_PERMS=0770
ACCT_USER_GROUPS=( syncthing )

acct-user_add_deps

pkg_postinst() {
	if [[ -n "${REPLACING_VERSIONS}" ]]; then
		local rver
		for rver in ${REPLACING_VERSIONS} ; do
			if ver_test "${rver}" -lt 1; then
				ewarn "The home directory of this user has changed to /var/lib/syncthing-discosrv"
				ewarn "If you have any files in /var/lib/${PN}, move them to the new location by hand"
				break
			fi
		done
	fi
}
