# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="A frantic 3D space shooter"
HOMEPAGE="http://jeuxlibres.net/showgame/sable.html"
SRC_URI="mirror://gentoo/${P}-src.tgz
	mirror://gentoo/${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="virtual/opengl
	media-libs/libsdl[joystick,opengl,sound,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer"
RDEPEND=${DEPEND}

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

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
