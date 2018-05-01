# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop

DESCRIPTION="A Tetris clone written in OpenGL"
HOMEPAGE="http://fbg.sourceforge.net/"
SRC_URI="mirror://sourceforge/fbg/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/opengl
	virtual/glu
	dev-games/physfs
	media-libs/libsdl[opengl,video]
	media-libs/libmikmod
	x11-libs/libXt"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -i \
		-e "/FBGDATADIR=/s:\".*\":\"/usr/share/${PN}\":" \
		-e '/^datadir=/d' \
		configure || die
}

src_configure() {
	econf --disable-fbglaunch
}

src_install() {
	default
	newicon startfbg/icon.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Falling Block Game" ${PN}
	rm -rf "${ED}/usr/doc"
}
