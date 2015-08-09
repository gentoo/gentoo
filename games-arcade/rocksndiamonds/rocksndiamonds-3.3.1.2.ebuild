# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit flag-o-matic eutils games

DESCRIPTION="A Boulderdash clone"
HOMEPAGE="http://www.artsoft.org/rocksndiamonds/"
SRC_URI="http://www.artsoft.org/RELEASES/unix/rocksndiamonds/${P}.tar.gz
	http://www.artsoft.org/RELEASES/rocksndiamonds/levels/Contributions-1.2.0.zip
	http://www.artsoft.org/RELEASES/rocksndiamonds/levels/BD2K3-1.0.0.zip
	http://www.artsoft.org/RELEASES/rocksndiamonds/levels/Boulder_Dash_Dream-1.0.0.zip
	http://www.artsoft.org/RELEASES/rocksndiamonds/levels/rnd-contrib-1.0.0.tar.gz
	http://www.artsoft.org/RELEASES/rocksndiamonds/levels/Snake_Bite-1.0.0.zip
	http://www.artsoft.org/RELEASES/rocksndiamonds/levels/Sokoban-1.0.0.zip
	http://www.artsoft.org/RELEASES/unix/rocksndiamonds/levels/rockslevels-emc-1.0.tar.gz
	http://www.artsoft.org/RELEASES/unix/rocksndiamonds/levels/rockslevels-sp-1.0.tar.gz
	http://www.artsoft.org/RELEASES/unix/rocksndiamonds/levels/rockslevels-dx-1.0.tar.gz
	mirror://gentoo/rnd_jue-v8.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="X sdl"

RDEPEND="X? ( x11-libs/libX11 )
	!sdl? ( x11-libs/libX11 )
	sdl? (
		>=media-libs/libsdl-1.2.3[joystick,video]
		>=media-libs/sdl-mixer-1.2.4[mod,mp3,timidity]
		media-libs/sdl-net
		>=media-libs/sdl-image-1.2.2[gif]
		media-libs/smpeg
	)"
DEPEND="${RDEPEND}
	app-arch/unzip
	X? ( x11-libs/libXt )
	!sdl? ( x11-libs/libXt )"

src_unpack() {
	unpack ${P}.tar.gz
	cd "${S}"
	unpack \
		rockslevels-emc-1.0.tar.gz \
		rockslevels-sp-1.0.tar.gz \
		rockslevels-dx-1.0.tar.gz
	cd levels
	unpack \
		rnd_jue-v8.tar.bz2 \
		BD2K3-1.0.0.zip \
		rnd-contrib-1.0.0.tar.gz \
		Snake_Bite-1.0.0.zip \
		Contributions-1.2.0.zip \
		Boulder_Dash_Dream-1.0.0.zip \
		Sokoban-1.0.0.zip
}

src_prepare() {
	# make it parallel-friendly.
	epatch \
		"${FILESDIR}"/${P}-parallel-build.patch \
		"${FILESDIR}"/${P}-perms.patch
	sed -i \
		-e 's:\$(MAKE_CMD):$(MAKE) -C $(SRC_DIR):' \
		-e '/^MAKE/d' \
		-e '/^CC/d' \
		Makefile || die

	sed -i \
		-e '/^LDFLAGS/s/=/+=/' \
		src/Makefile || die
}

src_compile() {
	replace-cpu-flags k6 k6-1 k6-2 i586

	local makeopts="RO_GAME_DIR=${GAMES_DATADIR}/${PN} RW_GAME_DIR=${GAMES_STATEDIR}/${PN}"
	if use X || { ! use X && ! use sdl; } ; then
		emake -j1 clean
		emake ${makeopts} OPTIONS="${CFLAGS}" x11
		mv rocksndiamonds{,.x11}
	fi
	if use sdl ; then
		emake -j1 clean
		emake ${makeopts} OPTIONS="${CFLAGS}" sdl
		mv rocksndiamonds{,.sdl}
	fi
}

src_install() {
	if use X || { ! use X && ! use sdl; } ; then
		dogamesbin rocksndiamonds.x11
	fi
	if use sdl ; then
		dogamesbin rocksndiamonds.sdl
		dosym rocksndiamonds.sdl "${GAMES_BINDIR}/rocksndiamonds"
	else
		dosym rocksndiamonds.x11 "${GAMES_BINDIR}/rocksndiamonds"
	fi
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r docs graphics levels music sounds

	newman rocksndiamonds.{1,6}
	dodoc CREDITS ChangeLog README
	newicon graphics/gfx_classic/rocks_icon_32x32.pcx ${PN}.pcx
	make_desktop_entry rocksndiamonds "Rocks 'N' Diamonds" /usr/share/pixmaps/${PN}.pcx

	prepgamesdirs
}
