# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop pax-utils rpm xdg-utils

DESCRIPTION="Project collaboration and tracking software for upwork.com"
HOMEPAGE="https://www.upwork.com/"
SRC_URI="
	amd64? ( https://updates-desktopapp.upwork.com/binaries/v${PV//./_}_941af939eff74e21/${P}-1fc24.x86_64.rpm -> ${P}_x86_64.rpm )
	x86? ( https://updates-desktopapp.upwork.com/binaries/v${PV//./_}_941af939eff74e21/${P}-1fc24.i386.rpm -> ${P}_i386.rpm )"

LICENSE="ODESK"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="bindist mirror"

RDEPEND="
	dev-libs/expat
	dev-libs/nspr
	dev-libs/nss
	gnome-base/gconf
	media-libs/alsa-lib
	media-libs/freetype
	sys-apps/dbus
	sys-libs/libcap
	x11-libs/gtk+:3[cups]
	x11-libs/libXinerama
	x11-libs/libXScrnSaver
	x11-libs/libXtst
"

S="${WORKDIR}"

PATCHES=( "${FILESDIR}/${PN}-desktop-r2.patch" )

# Binary only distribution
QA_PREBUILT="*"

src_install() {
	pax-mark m opt/Upwork/upwork

	insinto /opt
	doins -r opt/Upwork
	fperms 0755 /opt/Upwork/upwork

	insinto /usr/share
	doins -r usr/share/icons

	domenu usr/share/applications/upwork.desktop
	doicon usr/share/icons/hicolor/128x128/apps/upwork.png
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
