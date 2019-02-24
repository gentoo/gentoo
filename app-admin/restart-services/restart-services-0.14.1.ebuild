# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Tool to manage OpenRC services that need to be restarted"
HOMEPAGE="https://dev.gentoo.org/~mschiff/restart-services/"
SRC_URI="https://dev.gentoo.org/~mschiff/src/${PN}/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="
	app-admin/lib_users
	sys-apps/openrc
"

src_install() {
	dosbin restart-services
	doman restart-services.1
	keepdir /etc/restart-services.d
	insinto /etc
	doins restart-services.conf
	dodoc README CHANGES

	# remove after 2018/07/01
	dosym restart-services /usr/sbin/restart_services

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
			einfo "Migrating config"
			if [[ -e /etc/restart-services.d ]]; then
				ewarn "/etc/restart-services.d already exists?!"
				return
			fi
			if [[ -e /etc/restart-services.conf ]]; then
				ewarn "/etc/restart-services.conf already exists?!"
				return
			fi

			if [[ -f /etc/restart_services.d/00-local.conf ]]; then
				sed -i 's/restart_services/restart-services/g' \
					/etc/restart_services.d/00-local.conf
			fi
			if [[ $(ls /etc/restart_services.d/) ]]; then
				mv -v /etc/restart_services.d/* /etc/restart-services.d/
			fi
			if [[ -f /etc/restart_services.d/.keep_app-admin_restart_services-0 ]]; then
				rm -v /etc/restart_services.d/.keep_app-admin_restart_services-0
			fi
			if [[ -d /etc/restart_services.d ]]; then
				rmdir -v /etc/restart_services.d
			fi

			if [[ -f /etc/restart_services.conf ]]; then
				sed -i 's/restart_services/restart-services/g' \
					/etc/restart_services.conf
				mv /etc/restart_services.conf /etc/restart-services.conf
			fi
			einfo "done"
		fi
	fi
}
