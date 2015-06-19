# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/flobopuyo/flobopuyo-0.20-r1.ebuild,v 1.10 2015/02/19 19:59:07 tupone Exp $

EAPI=5
inherit toolchain-funcs eutils games

DESCRIPTION="Clone of the famous PuyoPuyo game"
HOMEPAGE="http://www.ios-software.com/?page=projet&quoi=29"
SRC_URI="http://www.ios-software.com/flobopuyo/${P}.tgz
	mirror://gentoo/${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE="opengl"

DEPEND="media-libs/libsdl
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-mixer[mod]
	opengl? ( virtual/opengl )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gcc4.patch \
		"${FILESDIR}"/${P}-gcc41.patch \
		"${FILESDIR}"/${P}-libs.patch

	find . -type f -name ".*" -exec rm -f \{\} \;
	sed -i \
		-e "s:^DATADIR=.*:DATADIR=\"${GAMES_DATADIR}/${PN}\":" \
		-e "/^INSTALL_BINDIR/s:/\$(PREFIX)/games:${GAMES_BINDIR}:" \
		Makefile \
		|| die
}

src_compile() {
	emake CXX="$(tc-getCXX)" \
		ENABLE_OPENGL="$(use opengl && echo true || echo false)"
}

src_install() {
	default
	doman man/flobopuyo.6
	doicon "${DISTDIR}/${PN}.png"
	make_desktop_entry flobopuyo FloboPuyo
	prepgamesdirs
}
