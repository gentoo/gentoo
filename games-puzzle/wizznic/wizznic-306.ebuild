# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="Block-clearing puzzle game"
HOMEPAGE="http://wizznic.sourceforge.net/"
SRC_URI="mirror://sourceforge/wizznic/Wizznic_src_build_${PV}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-libs/libsdl[sound,joystick,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]"

S=${WORKDIR}/Wizznic_src_build_${PV}

src_prepare() {
	sed \
		-e '/^\(CC\|LD\|STRIP\)/d' \
		-e 's/(LD)/(CC)/g' \
		-e '/man1/s/1/6/g' \
		Makefile.linux > Makefile || die
	mv doc/wizznic.1 doc/wizznic.6 || die
	sed -i \
		-e '/Dt WIZZNIC/s/1/6/' \
		doc/wizznic.6 || die
}

src_compile() {
	emake \
		DATADIR="${GAMES_DATADIR}/${PN}/" \
		BINDIR="${GAMES_BINDIR}" \
		STRIP=true
}

src_install() {
	emake \
		DESTDIR="${D}" \
		DATADIR="${GAMES_DATADIR}/${PN}/" \
		BINDIR="${GAMES_BINDIR}" \
		install
	dodoc doc/{changelog.txt,credits.txt,media-licenses.txt,ports.txt,readme.txt}
	newicon data/wmicon.png ${PN}.png
	make_desktop_entry wizznic "Wizznic!"
	prepgamesdirs
}
