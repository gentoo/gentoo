# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Tool to manage OpenRC and systemd services that need to be restarted"
HOMEPAGE="https://dev.gentoo.org/~mschiff/restart-services/"
SRC_URI="https://dev.gentoo.org/~mschiff/src/${PN}/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc x86"
IUSE=""

DEPEND=""
RDEPEND="
	app-admin/lib_users
	|| ( sys-apps/openrc sys-apps/systemd )
	app-portage/portage-utils
"

src_install() {
	dosbin restart-services
	doman restart-services.1
	keepdir /etc/restart-services.d
	insinto /etc
	doins restart-services.conf
	dodoc README CHANGES

	sed -i 's/^#include/include/' "${D}"/etc/restart-services.conf
	cat>"${D}"/etc/restart-services.d/00-local.conf<<-EOF
	# You may put your local changes here or in any other *.conf file
	# in this directory so you can leave /etc/restart-services.conf as is.
	# Example:
	# *extend* SV_ALWAYS to match 'myservice'
	# SV_ALWAYS+=( myservice )
	EOF
}

pkg_postinst() {
	local MAJOR MINOR
	# migrate config data for versions < 0.13.2
	if [[ $REPLACING_VERSIONS ]]; then
		MAJOR=${REPLACING_VERSIONS%%.*}
		MINOR=${REPLACING_VERSIONS%.*}
		MINOR=${MINOR#*.}

		if [[ $MAJOR -eq 0 && $MINOR -lt 14 ]]; then
			einfo "Checking for old config"
			if [[ -f /etc/restart_services.conf ]]; then
				ewarn "Old config file found: /etc/restart_services.conf"
				ewarn "It will be ignored so please migrate settings to a file in"
				ewarn "/etc/restart-services.d/ and/or remove /etc/restart_services.conf"
			fi
			if [[ -d /etc/restart_services.d ]]; then
				ewarn "Old config directory found: /etc/restart_services.d"
				ewarn "It will be ignored so please migrate files to /etc/restart-services.d"
				ewarn "and/or remove /etc/restart_services.d"
			fi
			einfo "done"
		fi
	fi
}
