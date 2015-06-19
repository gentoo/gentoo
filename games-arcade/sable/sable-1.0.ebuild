# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/sable/sable-1.0.ebuild,v 1.8 2015/01/05 17:28:37 tupone Exp $

EAPI=5
inherit eutils games

DESCRIPTION="A frantic 3D space shooter"
HOMEPAGE="http://www.stanford.edu/~mcmartin/sable/"
SRC_URI="http://www.stanford.edu/~mcmartin/${PN}/${P}-src.tgz
	mirror://gentoo/${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="virtual/opengl
	media-libs/libsdl
	media-libs/sdl-image[png]
	media-libs/sdl-mixer"
RDEPEND="${DEPEND}"
S=${WORKDIR}/${PN}

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_compile() {
	emake INSTALL_RESDIR="${GAMES_DATADIR}"
}

src_install() {
	dogamesbin ${PN}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r models sfx textures
	dodoc ChangeLog README

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} Sable

	prepgamesdirs
}
