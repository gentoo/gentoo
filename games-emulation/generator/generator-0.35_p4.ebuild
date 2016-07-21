# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils toolchain-funcs games

MY_P=${PN}-${PV/_p/-cbiere-r}
DESCRIPTION="Sega Genesis / Mega Drive emulator"
HOMEPAGE="http://www.squish.net/generator/"
SRC_URI="http://www.squish.net/generator/cbiere/generator/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="+sdlaudio"

DEPEND="virtual/jpeg:0
	media-libs/libsdl[joystick,video]
	sdlaudio? ( media-libs/libsdl[sound] )"
RDEPEND=${DEPEND}

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-configure.patch \
		"${FILESDIR}"/${P}-underlink.patch

	sed -i -e 's/@GTK_CFLAGS@//g' main/Makefile.am || die
	eautoreconf
}

src_configure() {
	egamesconf \
		--with-cmz80 \
		--with-sdl \
		--without-tcltk \
		--with-gcc=$(gcc-major-version) \
		$(use_with sdlaudio sdl-audio)
}

src_compile() {
	[[ -f Makefile ]] && emake clean
	emake -j1
}

src_install() {
	dogamesbin main/generator-sdl
	dodoc AUTHORS ChangeLog NEWS README TODO docs/*
	prepgamesdirs
}
