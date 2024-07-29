# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Gameboy / Gameboy Color emulator"
HOMEPAGE="http://m.peponas.free.fr/gngb/"
SRC_URI="http://m.peponas.free.fr/gngb/download/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="opengl"

RDEPEND="
	app-arch/bzip2:=
	media-libs/libsdl[sound,joystick,video]
	sys-libs/zlib:=
	opengl? ( media-libs/libglvnd[X] )"
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
	"${FILESDIR}"/${P}-gentoo-zlib.patch
	"${FILESDIR}"/${P}-clang16.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	append-cflags -std=gnu89 # old codebase, incompatible with c2x

	econf $(use_enable opengl gl)
}
