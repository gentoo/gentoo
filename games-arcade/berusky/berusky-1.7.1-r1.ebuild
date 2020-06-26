# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop gnome2

DATAFILE="${PN}-data-1.7"
DESCRIPTION="Free logic game based on an ancient puzzle named Sokoban"
HOMEPAGE="https://anakreon.cz/?q=node/1"
SRC_URI="https://www.anakreon.cz/download/${P}.tar.gz
	https://www.anakreon.cz/download/${DATAFILE}.tar.gz
	https://dev.gentoo.org/~hasufell/distfiles/${PN}.png"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/libsdl[X,video]
	media-libs/sdl-image[png]
	x11-libs/gtk+:2
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_install() {
	gnome2_src_install
	rm -rf "${ED}"/usr/doc
	doicon -s 32 "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN}
}
