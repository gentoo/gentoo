# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=5
inherit eutils toolchain-funcs games

MY_DATA_V="2005-12-21"
MY_DATA_P="${PN}data-${MY_DATA_V}"
DESCRIPTION="Worms of Prey - A multi-player, real-time clone of Worms"
HOMEPAGE="http://wormsofprey.org/"
SRC_URI="http://wormsofprey.org/download/${P}-src.tar.bz2
	http://wormsofprey.org/download/${MY_DATA_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE=""

RDEPEND="media-libs/libsdl
	media-libs/sdl-net
	media-libs/sdl-image
	media-libs/sdl-mixer
	media-libs/sdl-ttf"
DEPEND="${RDEPEND}
	x11-misc/makedepend"

MY_DATA_S=${WORKDIR}/${MY_DATA_P}

src_prepare() {
	# correct path to global woprc
	sed -i \
		-e "s:/etc/woprc:${GAMES_SYSCONFDIR}/woprc:g" \
		src/wopsettings.cpp \
		|| die "sed failed"
	# patch global woprc with the correct data files location and install it
	sed -i \
		-e "s:^data =.*$:data = ${GAMES_DATADIR}/${PN}:" \
		woprc \
		|| die "sed failed"
	epatch "${FILESDIR}"/${P}-Makefile.patch \
		"${FILESDIR}"/${P}-gcc43.patch
}

src_compile() {
	emake CXX=$(tc-getCXX)
}

src_install() {
	dogamesbin bin/${PN}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r "${MY_DATA_S}"/*
	insinto "${GAMES_SYSCONFDIR}"
	doins woprc
	newicon "${MY_DATA_S}"/images/misc/icons/wop16.png ${PN}.png
	make_desktop_entry wop "Worms of Prey"
	dodoc AUTHORS ChangeLog README{,-Libraries.txt} REVIEWS
	prepgamesdirs
}
