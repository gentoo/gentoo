# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/briquolo/briquolo-0.5.7.ebuild,v 1.5 2015/01/03 17:08:17 tupone Exp $

EAPI=4
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
	media-libs/libsdl
	media-libs/sdl-mixer
	media-libs/sdl-ttf
	media-libs/libpng
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-libpng14.patch
	# no thanks we'll take care of it.
	sed -i \
		-e '/^SUBDIRS/s/desktop//' \
		Makefile.in \
		|| die "sed Makefile.in failed"
	sed -i \
		-e "/CXXFLAGS/s:-O3:${CXXFLAGS}:" \
		-e 's:=.*share/locale:=/usr/share/locale:' \
		configure \
		|| die "sed configure failed"
	sed -i \
		-e 's:$(datadir)/locale:/usr/share/locale:' \
		po/Makefile.in.in \
		|| die "sed Makefile.in.in failed"
}

src_configure() {
	egamesconf \
		$(use_enable nls)
}

src_install() {
	default
	doicon desktop/briquolo.svg
	make_desktop_entry briquolo Briquolo
	prepgamesdirs
}
