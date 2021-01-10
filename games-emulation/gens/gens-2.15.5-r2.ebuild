# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MULTILIB_COMPAT=( abi_x86_32 )

inherit desktop flag-o-matic multilib-build

DESCRIPTION="A Sega Genesis/CD/32X emulator"
HOMEPAGE="https://sourceforge.net/projects/gens/"
SRC_URI="mirror://sourceforge/gens/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libsdl[${MULTILIB_USEDEP},joystick,video]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	virtual/opengl[${MULTILIB_USEDEP}]
	x11-libs/gtk+:2[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-lang/nasm-0.98"

PATCHES=(
	"${FILESDIR}"/${P}-romsdir.patch
	"${FILESDIR}"/${P}-as-needed.patch
	"${FILESDIR}"/${P}-ovflfix.patch
	"${FILESDIR}"/${P}-gcc34.patch
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-zlib-OF.patch
)

src_configure() {
	append-ldflags -Wl,-z,noexecstack
	use amd64 && multilib_toolchain_setup x86 #441876

	econf \
		--disable-gtktest \
		--disable-sdltest
}

src_install() {
	default
	dodoc gens.txt history.txt

	newicon pixmaps/gens_small.png gens.png
	make_desktop_entry "gens" "Gens"
}
