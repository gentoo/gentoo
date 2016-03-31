# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic games

DESCRIPTION="clone of old-school Wizardry(tm) games by SirTech"
HOMEPAGE="http://icculus.org/gwiz/"
SRC_URI="http://icculus.org/gwiz/${P}.tar.bz2"

KEYWORDS="~alpha amd64 ppc x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-libs/libsdl-1.2.3[joystick,video]
	>=media-libs/sdl-image-1.2.1-r1[png]
	>=media-libs/sdl-ttf-2.0.4"
RDEPEND=${DEPEND}

src_prepare() {
	epatch "${FILESDIR}"/${P}-buffer.patch
	append-cflags -std=gnu89 # build with gcc5 (bug #572532)
}

src_install() {
	DOCS="AUTHORS ChangeLog README doc/HOWTO-PLAY" \
		default
	newicon pixmaps/gwiz_icon.xpm ${PN}.xpm
	make_desktop_entry gwiz Gwiz
}
