# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit flag-o-matic eutils games

DESCRIPTION="A space adventure/combat game"
HOMEPAGE="https://sourceforge.net/projects/epiar/"
SRC_URI="mirror://sourceforge/epiar/${P}.0-src.zip"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~x86-fbsd"
IUSE=""

RDEPEND="media-libs/libsdl[video]
	media-libs/sdl-image[png]"
DEPEND="${RDEPEND}
	x11-libs/libX11
	virtual/opengl
	app-arch/unzip"

S=${WORKDIR}

src_prepare() {
	sed -i \
		-e "/^CFLAGS/s:-pg -g:${CFLAGS} ${LDFLAGS}:" \
		Makefile.linux || die
	epatch \
		"${FILESDIR}"/${P}-paths.patch \
		"${FILESDIR}"/${P}-gcc41.patch \
		"${FILESDIR}"/${P}-Makefile.linux.patch \
		"${FILESDIR}"/${P}-underlink.patch
	sed -i \
		-e "s:GENTOO_DATADIR:${GAMES_DATADIR}/${PN}/:" \
		src/main.c || die
}

src_compile() {
	emake -f Makefile.linux
}

src_install() {
	dogamesbin epiar
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r missions *.eaf
	keepdir "${GAMES_DATADIR}"/${PN}/plugins
	dodoc AUTHORS ChangeLog README
	prepgamesdirs
}
