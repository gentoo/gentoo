# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils desktop xdg-utils

DESCRIPTION="Holiday-themed sequel to the Japanese visual novel and dating sim about birds"
HOMEPAGE="https://www.devolverdigital.com/games/hatoful-boyfriend-holiday-star"
SRC_URI="Linux-Standalone-${PV}.rar"
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="+gui"
RESTRICT="bindist fetch splitdebug"

DEPEND="app-arch/unrar"

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

S="${WORKDIR}/Linux-Standalone"

DIR="/opt/${PN}"
QA_PREBUILT="${DIR#/}/*"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  https://www.humblebundle.com/store/${PN}"
	einfo "and move it to your distfiles directory."
}

src_install() {
	exeinto "${DIR}"
	newexe HB2.$(usex amd64 x86_64 x86) HB2
	make_wrapper ${PN} "${DIR}"/HB2

	insinto "${DIR}"
	doins -r HB2_Data/
	rm -r "${ED}/${DIR}"/HB2_Data/*/$(usex amd64 x86 x86_64) || die

	if ! use gui; then
		rm "${ED}/${DIR}"/HB2_Data/Plugins/*/ScreenSelector.so || die
	fi

	newicon -s 128 HB2_Data/Resources/UnityPlayer.png ${PN}.png
	make_desktop_entry ${PN} "Hatoful Boyfriend - Holiday Star"
}

pkg_postinst() { xdg_icon_cache_update; }
pkg_postrm() { xdg_icon_cache_update; }
