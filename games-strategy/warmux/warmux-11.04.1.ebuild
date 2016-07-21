# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils games

DESCRIPTION="A free Worms clone"
HOMEPAGE="http://gna.org/projects/warmux/"
SRC_URI="http://download.gna.org/warmux/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="debug nls unicode"

RDEPEND="media-libs/libsdl[joystick,video,X]
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf
	media-libs/sdl-net
	>=media-libs/sdl-gfx-2.0.22
	net-misc/curl
	media-fonts/dejavu
	dev-libs/libxml2
	x11-libs/libX11
	nls? ( virtual/libintl )
	unicode? ( dev-libs/fribidi )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${PN}-11.04

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gentoo.patch \
		"${FILESDIR}"/${P}-zlib.patch \
		"${FILESDIR}"/${P}-action.patch \
		"${FILESDIR}"/${P}-gcc47.patch \
		"${FILESDIR}"/${P}-stat.patch
	eautoreconf
}

src_configure() {
	egamesconf \
		--with-localedir-name=/usr/share/locale \
		--with-datadir-name="${GAMES_DATADIR}/${PN}" \
		--with-font-path=/usr/share/fonts/dejavu/DejaVuSans.ttf \
		$(use_enable debug) \
		$(use_enable nls) \
		$(use_enable unicode fribidi)
}

src_install() {
	default
	rm -f "${D}${GAMES_DATADIR}/${PN}/font/DejaVuSans.ttf"
	doicon data/icon/warmux.svg
	make_desktop_entry warmux Warmux
	prepgamesdirs
}
