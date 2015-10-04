# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils games

DESCRIPTION="The crystal MUD client"
HOMEPAGE="http://www.evilmagic.org/crystal/"
SRC_URI="http://www.evilmagic.org/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="sys-libs/zlib
	sys-libs/ncurses:0=
	dev-libs/openssl:0=
	virtual/libiconv"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-build.patch
	# avoid colliding with xscreensaver (bug #281191)
	mv crystal.6 crystal-mud.6 || die
	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	egamesconf --disable-scripting
}

src_install() {
	default
	prepgamesdirs
}
