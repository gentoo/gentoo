# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg-utils

MY_PN="Hatoful Boyfriend"
DESCRIPTION="Japanese visual novel and dating simulator where birds rule the Earth"
HOMEPAGE="https://www.devolverdigital.com/games/hatoful-boyfriend"
SRC_URI="${MY_PN// /_}_Linux.zip"
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="+gui"
RESTRICT="bindist fetch splitdebug"

RDEPEND="
	virtual/glu
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXext
	x11-libs/libXrandr
	gui? (
		dev-libs/atk
		dev-libs/glib:2
		media-libs/fontconfig:1.0
		media-libs/freetype:2
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:2
		x11-libs/pango
	)
"
BDEPEND="app-arch/unzip"

S="${WORKDIR}/${MY_PN}_Linux"

DIR="/opt/${PN}"
QA_PREBUILT="${DIR#/}/*"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  https://www.humblebundle.com/store/${PN}"
	einfo "and move it to your distfiles directory."
}

src_install() {
	exeinto "${DIR}"
	newexe hatoful.$(usex amd64 x86_64 x86) hatoful
	dosym "${DIR}"/hatoful /usr/bin/${PN}

	insinto "${DIR}"
	doins -r hatoful_Data/
	rm -r "${ED}/${DIR}"/hatoful_Data/*/$(usex amd64 x86 x86_64) || die

	if ! use gui; then
		rm "${ED}/${DIR}"/hatoful_Data/Plugins/*/ScreenSelector.so || die
	fi

	newicon -s 128 hatoful_Data/Resources/UnityPlayer.png ${PN}.png
	make_desktop_entry ${PN} "${MY_PN}"
}

pkg_postinst() { xdg_icon_cache_update; }
pkg_postrm() { xdg_icon_cache_update; }
