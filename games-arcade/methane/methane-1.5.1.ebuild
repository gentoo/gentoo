# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="Port from an old amiga game"
HOMEPAGE="http://methane.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-games/clanlib:2.3[opengl,mikmod]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	sed -i \
		-e "s:@GENTOO_DATADIR@:${GAMES_DATADIR}:" \
		sources/target.cpp || die

	# fix weird parallel make issue wrt #450422
	mkdir build || die
}

src_install() {
	dogamesbin methane
	insinto "${GAMES_DATADIR}"/${PN}
	doins resources/*
	dodir "${GAMES_STATEDIR}"
	touch "${D}/${GAMES_STATEDIR}"/methanescores
	fperms g+w "${GAMES_STATEDIR}"/methanescores
	newicon docs/puff.gif ${PN}.gif
	make_desktop_entry ${PN} "Super Methane Brothers" /usr/share/pixmaps/${PN}.gif
	dodoc authors.txt history.txt readme.txt
	dohtml docs/*
	prepgamesdirs
}
