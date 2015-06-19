# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-roguelike/scourge/scourge-0.21.1.ebuild,v 1.9 2015/02/27 21:50:41 tupone Exp $

EAPI=5
inherit autotools eutils wxwidgets games

DESCRIPTION="A graphical rogue-like adventure game"
HOMEPAGE="http://scourgeweb.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.src.tar.gz
	mirror://sourceforge/${PN}/${P}.data.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="virtual/glu
	virtual/opengl
	media-libs/freetype:2
	media-libs/libsdl[joystick,video]
	media-libs/sdl-image[png]
	media-libs/sdl-net
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf
	virtual/libintl"
DEPEND="${RDEPEND}
	sys-devel/gettext"

S=${WORKDIR}/${PN}

src_prepare() {
	# bug #257601
	sed -i \
		-e '/AC_CHECK_HEADERS.*glext/ s:):, [#include <GL/gl.h>] ):' \
		configure.in \
		|| die "sed failed"
	sed -i \
		-e '/snprintf/s/tmp, 256/tmp, sizeof(tmp)/' \
		src/scourgehandler.cpp || die
	epatch "${FILESDIR}"/${P}-gcc47.patch \
		"${FILESDIR}"/${P}-automake-1.13.patch
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	egamesconf \
		--with-data-dir="${GAMES_DATADIR}"/${PN} \
		--localedir=/usr/share/locale
}

src_install() {
	default
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r ../scourge_data/*
	doicon assets/scourge.png
	make_desktop_entry scourge S.C.O.U.R.G.E.
	prepgamesdirs
}
