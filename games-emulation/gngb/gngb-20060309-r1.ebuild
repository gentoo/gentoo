# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="Gameboy / Gameboy Color emulator"
HOMEPAGE="http://m.peponas.free.fr/gngb/"
SRC_URI="http://m.peponas.free.fr/gngb/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="opengl"

RDEPEND="
	media-libs/libsdl[sound,joystick,video]
	sys-libs/zlib
	app-arch/bzip2
	opengl? ( virtual/opengl )
"
DEPEND="${RDEPEND}"

PATCHES=(
	# From Debian
	"${FILESDIR}"/${P}-amd64.patch
	"${FILESDIR}"/${P}-gcc34.patch
	"${FILESDIR}"/${P}-gcc5.patch
	"${FILESDIR}"/${P}-gcc7.patch
	"${FILESDIR}"/${P}-inline.patch
	"${FILESDIR}"/${P}-joystick.patch
	"${FILESDIR}"/${P}-qwerty.patch
	# Ours
	"${FILESDIR}"/${P}-gcc10.patch
)

src_prepare() {
	default
	sed -i -e '70i#define OF(x) x' src/unzip.h || die
	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	econf $(use_enable opengl gl)
}
