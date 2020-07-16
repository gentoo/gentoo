# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils desktop xdg-utils

MY_PN="SatelliteReignLinux"
MY_PV="${PV/.}"
MY_PV="0${MY_PV/./_}"

DESCRIPTION="Real-time, class-based strategy game set in a cyberpunk city"
HOMEPAGE="http://satellitereign.com/"
SRC_URI="${MY_PN}${MY_PV}.zip"
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="+gui"
RESTRICT="bindist fetch splitdebug"

BDEPEND="app-arch/unzip"

RDEPEND="
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXrandr
	gui? (
		dev-libs/glib:2
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:2
	)
"

S="${WORKDIR}"

DIR="/opt/${PN}"
QA_PREBUILT="${DIR}/*"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  https://www.humblebundle.com/store/${PN}"
	einfo "and move it to your distfiles directory."
}

src_install() {
	exeinto "${DIR}"
	newexe ${MY_PN}.$(usex amd64 x86_64 x86) ${MY_PN}
	make_wrapper ${PN} "${DIR}"/${MY_PN}

	insinto "${DIR}"
	doins -r ${MY_PN}_Data/
	rm -r "${ED}/${DIR}"/${MY_PN}_Data/*/$(usex amd64 x86 x86_64) || die

	if ! use gui; then
		rm "${ED}/${DIR}"/${MY_PN}_Data/Plugins/*/ScreenSelector.so || die
	fi

	newicon -s 128 ${MY_PN}_Data/Resources/UnityPlayer.png ${PN}.png
	make_desktop_entry ${PN} "Satellite Reign"
}

pkg_postinst() { xdg_icon_cache_update; }
pkg_postrm() { xdg_icon_cache_update; }
