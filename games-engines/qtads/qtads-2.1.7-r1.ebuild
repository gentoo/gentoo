# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2-utils qmake-utils xdg flag-o-matic

DESCRIPTION="Multimedia interpreter for TADS text adventures"
HOMEPAGE="http://qtads.sourceforge.net"
SRC_URI="mirror://sourceforge/qtads/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libsdl[sound]
	media-libs/sdl-mixer[midi,vorbis]
	media-libs/sdl-sound[mp3]
	dev-qt/qtcore:5
	dev-qt/qtgui:5"
RDEPEND="${DEPEND}"

src_configure() {
	# bug 654356 temp fix
	append-cxxflags -fpermissive
	eqmake5 qtads.pro -after CONFIG-=silent
}

src_install() {
	dobin qtads
	dodoc AUTHORS HTML_TADS_LICENSE NEWS README
	insinto /usr
	doins -r share
}

pkg_preinst() {
	gnome2_icon_savelist
	xdg_pkg_preinst
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_pkg_postinst
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_pkg_postrm
}
