# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
RDEPEND=${DEPEND}

src_prepare() {
	epatch "${FILESDIR}"/${P}-ovflfix.patch
	sed -i -e '70i#define OF(x) x' src/unzip.h || die
	eautoreconf
}

src_configure() {
	egamesconf $(use_enable opengl gl)
}

src_install() {
	default
	prepgamesdirs
}
