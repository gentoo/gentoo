# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="you control a psychic bodyguard, and try to protect the VIP"
HOMEPAGE="http://www.wolfire.com/blackshades.html
	http://www.icculus.org/blackshades/"
SRC_URI="http://filesingularity.timedoctor.org/Textures.tar.bz2
	mirror://gentoo/${P}.tar.bz2"

LICENSE="blackshades"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="virtual/opengl
	virtual/glu
	media-libs/libvorbis
	media-libs/openal
	media-libs/freealut
	media-libs/libsdl"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	rm -rf Data/Textures
	rm -f ../Textures/{,Blood/}._*
	mv -f ../Textures Data || die "mv failed"
	epatch "${FILESDIR}"/${PN}-datadir.patch
	sed -i \
		-e "s/-O2 \(-Wall\) -g/${CXXFLAGS} \1/" \
		-e "/^LINKER/s:$: ${LDFLAGS}:" \
		Makefile \
		|| die "sed Makefile failed"
	sed -i "s:@DATADIR@:${GAMES_DATADIR}/${PN}:" \
		Source/Main.cpp \
		|| die "sed Main.cpp failed"
}

src_compile() {
	emake bindir
	emake
}

src_install() {
	newgamesbin objs/blackshades ${PN}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r Data
	dodoc IF_THIS_IS_A_README_YOU_HAVE_WON Readme TODO uDevGame_Readme
	make_desktop_entry ${PN} "Black Shades"
	prepgamesdirs
}
