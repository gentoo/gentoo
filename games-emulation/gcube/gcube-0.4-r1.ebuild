# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="Gamecube emulator"
HOMEPAGE="http://gcube.exemu.net/"
SRC_URI="http://gcube.exemu.net/downloads/${P}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="virtual/opengl
	media-libs/libsdl[sound,joystick,video]
	virtual/jpeg:0
	sys-libs/ncurses:0
	sys-libs/zlib"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PV}

src_prepare() {
	sed -i \
		-e '/^CFLAGS=-g/d' Makefile.rules \
		|| die "sed failed"
	epatch "${FILESDIR}"/${P}-ldflags.patch \
		"${FILESDIR}"/${P}-underlink.patch \
		"${FILESDIR}"/${P}-gcc47.patch
}

src_install() {
	local x

	dogamesbin gcmap gcube
	for x in bin2dol isopack thpview tplx ; do
		newgamesbin ${x} ${PN}-${x}
	done
	dodoc ChangeLog README
	prepgamesdirs
}
