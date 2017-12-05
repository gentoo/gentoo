# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils flag-o-matic games

DESCRIPTION="Block-clearing puzzle game"
HOMEPAGE="http://wizznic.org/"
SRC_URI="mirror://sourceforge/wizznic/Wizznic_src_build_${PV}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libsdl[sound,joystick,opengl,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	virtual/opengl"
RDEPEND=${DEPEND}

S=${WORKDIR}/Wizznic_src_build_${PV}

src_prepare() {
	sed \
		-e '/^\(CC\|LD\|STRIP\)/d' \
		-e 's/(LD)/(CC)/g' \
		-e '/man1/s/1/6/g' \
		-e '/CFLAGS.*=/d' \
		Makefile.linux > Makefile || die
	mv doc/wizznic.1 doc/wizznic.6 || die
	sed -i \
		-e '/Dt WIZZNIC/s/1/6/' \
		doc/wizznic.6 || die
	append-cflags -std=gnu89 # build with gcc5 (bug #574100)
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
