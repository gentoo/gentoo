# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
WX_GTK_VER="3.2-gtk3"

inherit desktop wxwidgets xdg

DESCRIPTION="Visualization and Audibilization of Sorting Algorithms"
HOMEPAGE="http://panthema.net/2013/sound-of-sorting/ https://github.com/bingmann/sound-of-sorting"
#SRC_URI="http://panthema.net/2013/sound-of-sorting/${P}.tar.bz2"
COMMIT="5cfcaf752593c8cbcf52555dd22745599a7d8b1b"
SRC_URI="https://github.com/bingmann/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~pacho/${PN}/${PN}_512.png"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	media-libs/libsdl
	x11-libs/wxGTK:${WX_GTK_VER}
"
DEPEND="${RDEPEND}"

src_configure() {
	setup-wxwidgets unicode
	default
}

src_install() {
	default
	make_desktop_entry ${PN} "Sound of Sorting"
	newicon -s 512 "${DISTDIR}/${PN}_512.png" ${PN}.png
}
