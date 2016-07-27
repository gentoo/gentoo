# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=5
inherit eutils toolchain-funcs games

DESCRIPTION="variant of the snake game"
HOMEPAGE="https://sourceforge.net/projects/worms3d/"
SRC_URI="mirror://sourceforge/worms3d/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-libs/sdl-net
	virtual/opengl
	media-libs/freeglut
	virtual/glu
	media-libs/libsdl"
RDEPEND="${DEPEND}"
S=${WORKDIR}/${PN}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-amd64.patch \
		"${FILESDIR}"/${P}-build.patch
}

src_compile() {
	emake CXX=$(tc-getCXX) -C src snake3d.linux
}

src_install() {
	dogamesbin ${PN}
	dodoc ChangeLog README TODO
	prepgamesdirs
}
