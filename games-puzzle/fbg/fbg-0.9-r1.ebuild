# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils games

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
RDEPEND=${DEPEND}

src_prepare() {
	sed -i \
		-e "/FBGDATADIR=/s:\".*\":\"${GAMES_DATADIR}/${PN}\":" \
		-e '/^datadir=/d' \
		configure || die
}

src_configure() {
	egamesconf --disable-fbglaunch
}

src_install() {
	default
	newicon startfbg/icon.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Falling Block Game" ${PN}
	rm -rf "${D}/${GAMES_PREFIX}"/doc
	prepgamesdirs
}
