# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils desktop unpacker xdg-utils

DESCRIPTION="Build railroads in order to connect cities, tunnels, and bridges"
HOMEPAGE="http://train-valley.com/tv1.html"
SRC_URI="${P//[-.]/_}.sh"
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="+gui"
RESTRICT="bindist fetch splitdebug"

RDEPEND="
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXrandr
	gui? (
		dev-libs/glib:2
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:2
	)
"

S="${WORKDIR}/data/noarch/game"

DIR="/opt/${PN}"
QA_PREBUILT="${DIR}/*"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  https://www.gog.com/game/${PN//-/_}"
	einfo "and move it to your distfiles directory."
}

src_unpack() {
	unpack_zip ${A}
}

src_install() {
	exeinto "${DIR}"
	newexe ${PN}.$(usex amd64 x86_64 x86) ${PN}
	make_wrapper ${PN} "${DIR}"/${PN}

	insinto "${DIR}"
	doins -r ${PN}_Data/
	rm -r "${ED}/${DIR}"/${PN}_Data/*/$(usex amd64 x86 x86_64) || die

	if ! use gui; then
		rm "${ED}/${DIR}"/${PN}_Data/Plugins/*/ScreenSelector.so || die
	fi

	newicon -s 128 ${PN}_Data/Resources/UnityPlayer.png ${PN}.png
	make_desktop_entry ${PN} "Train Valley"
}

pkg_postinst() { xdg_icon_cache_update; }
pkg_postrm() { xdg_icon_cache_update; }
