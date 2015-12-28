# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic autotools toolchain-funcs games

DESCRIPTION="8ball, 9ball, snooker and carambol game"
HOMEPAGE="http://foobillard.sourceforge.net/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE="sdl video_cards_nvidia"

DEPEND="x11-libs/libXaw
	x11-libs/libXi
	virtual/opengl
	virtual/glu
	>=media-libs/freetype-2.0.9
	media-libs/libpng:0
	sdl? ( media-libs/libsdl[video] )
	!sdl? ( media-libs/freeglut )"
RDEPEND=${DEPEND}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-no_nvidia.patch \
		"${FILESDIR}"/${P}-fbsd.patch \
		"${FILESDIR}"/${P}-as-needed.patch \
		"${FILESDIR}"/${P}-gl-clamp.patch
	mv configure.{in,ac}
	rm aclocal.m4

	eautoreconf
}

src_configure() {
	use video_cards_nvidia && append-ldflags -L/usr/$(get_libdir)/opengl/nvidia/lib
	egamesconf \
		--enable-sound \
		$(use_enable sdl SDL) \
		$(use_enable !sdl glut) \
		$(use_enable video_cards_nvidia nvidia)
}

src_install() {
	default
	doman foobillard.6
	newicon data/full_symbol.png foobillard.png
	make_desktop_entry foobillard Foobillard
	prepgamesdirs
}
