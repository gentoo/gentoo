# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs xdg

DESCRIPTION="Multi-platform Atari 2600 VCS Emulator"
HOMEPAGE="https://stella-emu.github.io"
SRC_URI="https://github.com/stella-emu/stella/releases/download/${PV}/${P}-src.tar.xz"

LICENSE="GPL-2+ BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+joystick png zlib"
REQUIRED_USE="png? ( zlib )"

RDEPEND="
	media-libs/libsdl2[joystick?,opengl,sound,video]
	png? ( media-libs/libpng:= )
	zlib? ( sys-libs/zlib:= )"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	sed -i '/CXXFLAGS+=/s/-fomit-frame-pointer//' Makefile || die
}

src_configure() {
	tc-export CC CXX

	# not an autotools generated script
	local configure=(
		./configure
		--host=${CHOST}
		--prefix="${EPREFIX}"/usr
		--docdir="${EPREFIX}"/usr/share/doc/${PF}/html
		$(use_enable joystick)
		$(use_enable png)
		$(use_enable zlib zip)
		${EXTRA_ECONF}
	)

	echo ${configure[*]}
	"${configure[@]}" || die
}

src_install() {
	local DOCS=(
		Announce.txt Changes.txt README-SDL.txt
		Readme.txt docs/R77_readme.txt Todo.txt
	)

	default

	rm "${ED}"/usr/share/doc/${PF}/html/*.txt || die
}
