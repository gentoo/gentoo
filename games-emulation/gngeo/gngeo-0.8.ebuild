# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils autotools flag-o-matic games

DESCRIPTION="A NeoGeo emulator"
HOMEPAGE="https://code.google.com/p/gngeo/"
SRC_URI="https://gngeo.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="virtual/opengl
	media-libs/libsdl[joystick,opengl,sound,video]
	sys-libs/zlib[minizip]"
RDEPEND=${DEPEND}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-execstacks.patch \
		"${FILESDIR}"/${P}-zlib.patch \
		"${FILESDIR}"/${P}-concurrentMake.patch \
		"${FILESDIR}"/${P}-cflags.patch
	mv configure.in configure.ac || die
	eautoreconf
	append-cflags -std=gnu89 # build with gcc5 (bug #571056)
}

src_configure() {
	egamesconf --disable-i386asm
}

src_install() {
	DOCS=( AUTHORS FAQ NEWS README* TODO sample_gngeorc )
	default
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	echo
	elog "A licensed NeoGeo BIOS copy is required to run the emulator."
	echo
}
