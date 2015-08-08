# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils scons-utils games

DESCRIPTION="Futuristic real-time strategy game"
HOMEPAGE="http://www.boswars.org/"
SRC_URI="http://www.boswars.org/dist/releases/${P}-src.tar.gz
	http://dev.gentoo.org/~hasufell/distfiles/${P}-fixed-images-for-libpng-1.6.tar.xz
	mirror://gentoo/bos.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="dev-lang/lua
	media-libs/libsdl[opengl,sound,video]
	media-libs/libpng:0
	media-libs/libvorbis
	media-libs/libtheora
	media-libs/libogg
	virtual/opengl
	x11-libs/libX11"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${P}-src

src_unpack() {
	default
	# bug 475764
	cp -dRp ${P}-fixed-images-for-libpng-1.6/* ${P}-src/ \
		|| die "copying fixed images failed!"
}

src_prepare() {
	rm -f doc/{README-SDL.txt,guichan-copyright.txt}
	epatch \
		"${FILESDIR}"/${P}-gentoo.patch \
		"${FILESDIR}"/${P}-scons-blows.patch
	sed -i \
		-e "s:@GENTOO_DATADIR@:${GAMES_DATADIR}/${PN}:" \
		engine/include/stratagus.h \
		|| die
	sed -i \
		-e "/-O2/s:-O2.*math:${CXXFLAGS} -Wall:" \
		SConstruct \
		|| die
}

src_compile() {
	escons || die
}

src_install() {
	newgamesbin build/${PN}-release ${PN}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r campaigns graphics intro languages maps patches scripts sounds units
	newicon "${DISTDIR}"/bos.png ${PN}.png
	make_desktop_entry ${PN} "Bos Wars"
	# COPYRIGHT.txt is referenced by the html
	dodoc CHANGELOG COPYRIGHT.txt README.txt
	dohtml -r doc/*
	prepgamesdirs
}
