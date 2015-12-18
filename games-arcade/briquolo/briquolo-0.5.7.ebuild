# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="Breakout with 3D representation based on OpenGL"
HOMEPAGE="http://briquolo.free.fr/en/index.html"
SRC_URI="http://briquolo.free.fr/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

RDEPEND="virtual/opengl
	virtual/glu
	media-libs/libsdl[joystick,sound,video]
	media-libs/sdl-mixer
	media-libs/sdl-ttf
	media-libs/libpng:0
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-libpng14.patch
	# no thanks we'll take care of it.
	sed -i \
		-e '/^SUBDIRS/s/desktop//' \
		Makefile.in || die
	sed -i \
		-e "/CXXFLAGS/s:-O3:${CXXFLAGS}:" \
		-e 's:=.*share/locale:=/usr/share/locale:' \
		configure || die
	sed -i \
		-e 's:$(datadir)/locale:/usr/share/locale:' \
		po/Makefile.in.in || die
}

src_configure() {
	egamesconf $(use_enable nls)
}

src_install() {
	default
	doicon desktop/briquolo.svg
	make_desktop_entry briquolo Briquolo
	prepgamesdirs
}
