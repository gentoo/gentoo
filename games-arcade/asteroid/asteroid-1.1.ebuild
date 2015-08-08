# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils games

DESCRIPTION="A modern version of the arcade classic that uses OpenGL"
HOMEPAGE="http://chaoslizard.sourceforge.net/asteroid/"
SRC_URI="mirror://sourceforge/chaoslizard/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE=""

DEPEND="virtual/opengl
	media-libs/freeglut
	virtual/glu
	media-libs/libsdl
	media-libs/sdl-mixer"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-include.patch )

src_install() {
	emake DESTDIR="${D}" install
	dodoc asteroid-{authors,changes,readme}.txt
	prepgamesdirs
}
