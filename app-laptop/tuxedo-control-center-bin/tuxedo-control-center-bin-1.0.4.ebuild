# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm systemd xdg-utils

MY_PN="${PN/-bin/}"

DESCRIPTION="Tool to control performance, energy, fan and comfort settings on TUXEDO laptops"
HOMEPAGE="https://github.com/tuxedocomputers/tuxedo-control-center"
SRC_URI="https://rpm.tuxedocomputers.com/opensuse/15.2/x86_64/${MY_PN}_${PV}.rpm"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE=""

RESTRICT="strip splitdebug"

DEPEND="sys-power/tuxedo-cc-wmi"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}"

src_prepare() {
	default
	rm -rf usr/lib
	mkdir files
}

src_install() {
	insinto /
	doins -r usr opt
	find . -type f -perm -a=x | while read f; do
		chmod 0755 "${D}/${f}"
	done

	dosym ../../opt/tuxedo-control-center/tuxedo-control-center /usr/bin/tuxedo-control-center

	insinto /usr/share/dbus-1/system.d/
	doins opt/tuxedo-control-center/resources/dist/tuxedo-control-center/data/dist-data/com.tuxedocomputers.tccd.conf

	insinto /usr/share/polkit-1/actions
	doins opt/tuxedo-control-center/resources/dist/tuxedo-control-center/data/dist-data/de.tuxedocomputers.tcc.policy

	systemd_dounit opt/tuxedo-control-center/resources/dist/tuxedo-control-center/data/dist-data/tccd.service
	systemd_dounit opt/tuxedo-control-center/resources/dist/tuxedo-control-center/data/dist-data/tccd-sleep.service
}

pkg_config() {
	ebegin "Reloading systemd"
	systemctl daemon-reload
	eend $?
	ebegin "Enabling and starting tccd.service"
	systemctl enable --now tccd
	eend $?
	ebegin "Enabling and starting tccd-sleep.service"
	systemctl enable --now tccd-sleep
	eend $?
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	elog
	elog "You need to enable tccd and tccd-sleep service before running tuxedo-control-center"
	elog
	elog "For your convenience you may just call:"
	elog "  emerge --config =${P}"
	elog
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
