# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/gngb/gngb-20060309.ebuild,v 1.10 2014/07/30 16:43:44 mr_bones_ Exp $

EAPI=5
inherit autotools eutils games

DESCRIPTION="Gameboy / Gameboy Color emulator"
HOMEPAGE="http://m.peponas.free.fr/gngb/"
SRC_URI="http://m.peponas.free.fr/gngb/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="opengl"

DEPEND="media-libs/libsdl[sound,joystick,video]
	sys-libs/zlib
	app-arch/bzip2
	opengl? ( virtual/opengl )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-ovflfix.patch
	sed -i -e '70i#define OF(x) x' src/unzip.h || die
	eautoreconf
}

src_configure() {
	egamesconf $(use_enable opengl gl)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README TODO
	prepgamesdirs
}
