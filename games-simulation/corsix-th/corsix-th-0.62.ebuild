# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils desktop eapi7-ver gnome2-utils

MY_PN="CorsixTH"
MY_PV="$(ver_rs 2 -)"

DESCRIPTION="Open source clone of Theme Hospital"
HOMEPAGE="http://corsixth.com"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="libav +midi +sound +truetype +videos"

RDEPEND=">=dev-lang/lua-5.1:0
	>=dev-lua/luafilesystem-1.5
	>=dev-lua/lpeg-0.9
	>=dev-lua/luasocket-3.0_rc1-r4
	media-libs/libsdl2[opengl,video]
	sound? ( media-libs/sdl2-mixer[midi?] )
	truetype? ( >=media-libs/freetype-2.5.3:2 )
	videos? (
		!libav? ( >=media-video/ffmpeg-2.2.3:0= )
		libav? ( >=media-video/libav-11.1:0= )
	)"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_PN}-${MY_PV}"

PATCHES=("${FILESDIR}"/${P}-gcc-10.patch)

src_configure() {
	local mycmakeargs=(
		-DWITH_AUDIO="$(usex sound)"
		-DWITH_FREETYPE2="$(usex truetype)"
		-DWITH_LIBAV="$(usex libav)"
		-DWITH_MOVIES="$(usex videos)"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc {changelog,CONTRIBUTING}.txt

	newicon -s scalable CorsixTH/Original_Logo.svg ${PN}.svg
	make_desktop_entry ${PN} "${MY_PN}"
}

pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
