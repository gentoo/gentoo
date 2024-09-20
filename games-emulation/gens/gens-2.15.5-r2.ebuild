# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop flag-o-matic multilib

DESCRIPTION="Sega Genesis/CD/32X emulator"
HOMEPAGE="https://sourceforge.net/projects/gens/"
SRC_URI="https://downloads.sourceforge.net/gens/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libsdl[abi_x86_32(-),joystick,video]
	sys-libs/zlib:=[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]
	x11-libs/gtk+:2[abi_x86_32(-)]"
DEPEND="${RDEPEND}"
BDEPEND="dev-lang/nasm"

PATCHES=(
	"${FILESDIR}"/${P}-romsdir.patch
	"${FILESDIR}"/${P}-as-needed.patch
	"${FILESDIR}"/${P}-ovflfix.patch
	"${FILESDIR}"/${P}-gcc34.patch
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-zlib-OF.patch
)

src_configure() {
	append-ldflags -Wl,-z,notext -Wl,-z,noexecstack
	use amd64 && multilib_toolchain_setup x86 #441876

	econf \
		--disable-gtktest \
		--disable-sdltest
}

src_install() {
	default

	dodoc gens.txt history.txt

	newicon pixmaps/gens_small.png gens.png
	make_desktop_entry gens Gens
}
