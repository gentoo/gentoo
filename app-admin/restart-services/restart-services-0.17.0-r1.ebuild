# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Tool to manage OpenRC and systemd services that need to be restarted"
HOMEPAGE="https://dev.gentoo.org/~mschiff/restart-services/"
SRC_URI="https://dev.gentoo.org/~mschiff/src/${PN}/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc x86"

RDEPEND="
	app-admin/lib_users
	app-portage/portage-utils
	|| ( sys-apps/openrc sys-apps/systemd )
"

src_install() {
	dosbin restart-services
	doman restart-services.1
	keepdir /etc/restart-services.d
	insinto /etc
	doins restart-services.conf
	dodoc README CHANGES

	sed -i -e 's/^#include/include/' "${ED}"/etc/restart-services.conf || die
	cat > "${ED}"/etc/restart-services.d/00-local.conf <<- EOF || die
	# You may put your local changes here or in any other *.conf file
	# in this directory so you can leave /etc/restart-services.conf as is.
	# Example:
	# *extend* SV_ALWAYS to match 'myservice'
	# SV_ALWAYS+=( myservice )
	EOF
}

pkg_postinst() {
	# migrate config data for versions < 0.13.2
	if [[ -n ${REPLACING_VERSIONS} ]]; then

		if [[ $(ver_cut 1 ${REPLACING_VERSIONS}) -eq 0 ]] \
				&& [[ $(ver_cut 2 ${REPLACING_VERSIONS}) -lt 14 ]]; then
			local have_old_config=0
			ebegin "Checking for old config"
			if [[ -f /etc/restart_services.conf ]]; then
				have_old_config=1
				ewarn "Old config file found: /etc/restart_services.conf"
				ewarn "It will be ignored so please migrate settings to a file in"
				ewarn "/etc/restart-services.d/ and/or remove /etc/restart_services.conf"
			fi
			if [[ -d /etc/restart_services.d ]]; then
				have_old_config=1
				ewarn "Old config directory found: /etc/restart_services.d"
				ewarn "It will be ignored so please migrate files to /etc/restart-services.d"
				ewarn "and/or remove /etc/restart_services.d"
			fi
			eend ${have_old_config}
		fi
	fi
}
