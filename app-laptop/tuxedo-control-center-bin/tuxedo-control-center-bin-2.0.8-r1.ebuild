# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm systemd xdg-utils

MY_PN="${PN/-bin/}"

DESCRIPTION="Tool to control performance, energy, fan and comfort settings on TUXEDO laptops"
HOMEPAGE="https://github.com/tuxedocomputers/tuxedo-control-center"
SRC_URI="https://rpm.tuxedocomputers.com/opensuse/15.4/x86_64/${MY_PN}_${PV}.rpm"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-* ~amd64"

RESTRICT="strip splitdebug"

DEPEND=">=app-laptop/tuxedo-drivers-3.2.14"
RDEPEND="
	${DEPEND}
	app-accessibility/at-spi2-core
	dev-libs/nss
	dev-libs/nspr
	media-libs/alsa-lib
	media-libs/mesa[X(+)]
	net-print/cups
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3[X]
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libdrm
	x11-libs/libxkbcommon
	x11-libs/libxshmfence
	x11-libs/pango
"
# See bug #827729
BDEPEND="app-arch/xz-utils[extra-filters(+)]"

S="${WORKDIR}"
QA_PREBUILT="opt/tuxedo-control-center/*"

src_prepare() {
	default
	rm -rf usr/lib || die "could not remove usr/lib"
	mkdir files || die "could not create files dir"
}

src_install() {
	insinto /
	doins -r usr opt
	find . -type f -perm -a=x | while read f; do
		fperms 0755 "${f/./}"
	done

	dosym ../../opt/tuxedo-control-center/tuxedo-control-center /usr/bin/tuxedo-control-center

	insinto /usr/share/dbus-1/system.d/
	doins opt/tuxedo-control-center/resources/dist/tuxedo-control-center/data/dist-data/com.tuxedocomputers.tccd.conf

	insinto /usr/share/polkit-1/actions
	doins opt/tuxedo-control-center/resources/dist/tuxedo-control-center/data/dist-data/com.tuxedocomputers.tccd.policy

	systemd_dounit opt/tuxedo-control-center/resources/dist/tuxedo-control-center/data/dist-data/tccd.service
	systemd_dounit opt/tuxedo-control-center/resources/dist/tuxedo-control-center/data/dist-data/tccd-sleep.service

	newinitd "${FILESDIR}/tccd.initd" tccd
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
	elog "For your convenience, if you use systemd, you may just call:"
	elog "  emerge --config =app-laptop/${PF}"
	elog
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
