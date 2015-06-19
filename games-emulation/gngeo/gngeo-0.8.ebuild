# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/gngeo/gngeo-0.8.ebuild,v 1.3 2015/02/25 15:57:48 ago Exp $

EAPI=5
inherit eutils autotools games

DESCRIPTION="A NeoGeo emulator"
HOMEPAGE="http://code.google.com/p/gngeo/"
SRC_URI="http://gngeo.googlecode.com/files/${P}.tar.gz"

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
		"${FILESDIR}"/${P}-concurrentMake.patch
	mv configure.in configure.ac || die
	eautoreconf
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
