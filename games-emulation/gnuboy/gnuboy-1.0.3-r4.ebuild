# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Gameboy emulator with multiple renderers"
HOMEPAGE="https://sourceforge.net/projects/gnuboy/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X +sdl"
REQUIRED_USE="!X? ( sdl )"

RDEPEND="
	X? (
		x11-libs/libX11
		x11-libs/libXext
	)
	sdl? ( media-libs/libsdl[joystick,sound,video] )"
DEPEND="
	${RDEPEND}
	X? ( x11-base/xorg-proto )"

PATCHES=(
	"${FILESDIR}"/${P}-exec-stack.patch
	"${FILESDIR}"/${P}-linux-headers.patch
	"${FILESDIR}"/${P}-include.patch
	"${FILESDIR}"/${P}-fix-implicit-decl-sprintf.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	# LTO type mismatches (bug #858701)
	append-flags -fno-strict-aliasing
	filter-lto

	local econfargs=(
		$(use_with X x)
		$(use_with sdl)
		$(use_enable x86 asm)
		--disable-arch
		--disable-optimize
	)

	econf "${econfargs[@]}"
}

src_install() {
	use X && dobin xgnuboy
	use sdl && dobin sdlgnuboy

	dodoc README docs/{CHANGES,CONFIG,CREDITS,FAQ,HACKING,WHATSNEW}
}
