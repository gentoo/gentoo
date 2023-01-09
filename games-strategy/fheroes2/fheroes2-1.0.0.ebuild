# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A recreation of Heroes of Might and Magic II game engine"
HOMEPAGE="https://ihhub.github.io/fheroes2/"
SRC_URI="https://github.com/ihhub/fheroes2/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+image"

BDEPEND="sys-devel/gettext"
DEPEND="
	media-libs/libsdl2
	media-libs/sdl2-mixer
	sys-libs/zlib:=
	image? ( media-libs/sdl2-image[png] )
"
RDEPEND="${DEPEND}
	virtual/libintl
"

src_prepare() {
	default
	sed -i -e "s:doc/README.txt:doc/INSTALL.md:g" -e "s:LICENSE::g" \
		CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	mycmakeargs=(
		-DUSE_SYSTEM_LIBSMACKER=OFF # broken
		-DUSE_SDL_VERSION=SDL2
		-DENABLE_IMAGE=$(usex image)
		-DENABLE_TOOLS=OFF
	)
	cmake_src_configure
}

pkg_postinst() {
	elog "In order to play you need copy of HoMM II or HoMM II: The Price of"
	elog "Loyalty data. Please read /usr/share/doc/${PF}/INSTALL.md for"
	elog "further instructions."
}
