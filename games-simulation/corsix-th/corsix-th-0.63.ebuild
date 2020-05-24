# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

MY_PN="CorsixTH"
MY_PV="$(ver_rs 2 -)"

DESCRIPTION="Open source clone of Theme Hospital"
HOMEPAGE="http://corsixth.com"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc +midi +sound +truetype +videos"

RDEPEND="
	>=dev-lang/lua-5.1:0
	>=dev-lua/luafilesystem-1.5
	>=dev-lua/lpeg-0.9
	>=dev-lua/luasocket-3.0_rc1-r4
	media-libs/libsdl2[opengl,video]
	sound? ( media-libs/sdl2-mixer[midi?] )
	truetype? ( >=media-libs/freetype-2.5.3:2 )
	videos? ( >=media-video/ffmpeg-2.2.3:0= )
"

DEPEND="${RDEPEND}"

BDEPEND="
	virtual/pkgconfig
	doc? (
		 app-doc/doxygen[dot]
		 >=dev-lang/lua-5.1:0
	)
"

S="${WORKDIR}/${MY_PN}-${MY_PV}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.62-gcc-10.patch
)

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWITH_AUDIO=$(usex sound)
		-DWITH_FREETYPE2=$(usex truetype)
		-DWITH_MOVIES=$(usex videos)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_src_compile doc
}

src_install() {
	cmake_src_install
	dodoc {changelog,CONTRIBUTING}.txt

	docinto html
	use doc && dodoc -r "${BUILD_DIR}"/doc/*
}
