# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/amoebax/amoebax-0.2.1.ebuild,v 1.3 2015/02/25 15:48:52 ago Exp $

EAPI=5
inherit autotools eutils games

DESCRIPTION="a cute and addictive action-puzzle game, similar to tetris"
HOMEPAGE="http://www.emma-soft.com/games/amoebax/"
SRC_URI="http://www.emma-soft.com/games/amoebax/download/${P}.tar.bz2"

LICENSE="FreeArt GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-libs/libsdl[sound,joystick,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]"
RDEPEND=${DEPEND}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-aclocal.patch \
		"${FILESDIR}"/${P}-compile.patch

	sed -i \
		-e "/^SUBDIRS/s:doc ::" \
		Makefile.am || die
	sed -i \
		-e "/^iconsdir/s:=.*:=/usr/share/pixmaps:" \
		-e "/^desktopdir/s:=.*:=/usr/share/applications:" \
		data/Makefile.am || die
	sed -i \
		-e '/Encoding/d' \
		-e '/Icon/s/.svg//' \
		data/amoebax.desktop || die
	AT_M4DIR=m4 eautoreconf
}

src_install() {
	default
	prepgamesdirs
}
