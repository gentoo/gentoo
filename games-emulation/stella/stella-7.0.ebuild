# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo toolchain-funcs xdg

DESCRIPTION="Multi-platform Atari 2600 VCS Emulator"
HOMEPAGE="https://stella-emu.github.io/"
SRC_URI="https://github.com/stella-emu/stella/releases/download/${PV}/${P}-src.tar.xz"

LICENSE="GPL-2+ BSD MIT OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+joystick png test zlib"
REQUIRED_USE="png? ( zlib )"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-db/sqlite:3
	media-libs/libsdl2[joystick?,opengl,sound,video]
	png? ( media-libs/libpng:= )
	zlib? ( sys-libs/zlib:= )
"
DEPEND="
	${RDEPEND}
	test? ( dev-cpp/gtest )
"
BDEPEND="
	virtual/pkgconfig
"

src_prepare() {
	default

	sed -i 's/pkg-config/${PKG_CONFIG}/' configure || die
	sed -i '/CXXFLAGS+=/s/-fomit-frame-pointer//' Makefile || die
}

src_configure() {
	tc-export CC CXX PKG_CONFIG

	local configure=(
		./configure # not autotools-based
		--host=${CHOST}
		--prefix="${EPREFIX}"/usr
		--docdir="${EPREFIX}"/usr/share/doc/${PF}/html
		$(use_enable joystick)
		$(use_enable png)
		$(use_enable zlib zip)
		${EXTRA_ECONF}
	)

	edo "${configure[@]}"
}

src_install() {
	local DOCS=(
		Announce.txt Changes.txt README.md README-SDL.txt
		docs/R77_readme.txt Todo.txt
	)

	default

	rm -- "${ED}"/usr/share/doc/${PF}/html/*.{md,txt} || die
}
