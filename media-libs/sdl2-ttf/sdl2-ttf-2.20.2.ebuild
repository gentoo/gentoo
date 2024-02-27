# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

MY_P="SDL2_ttf-${PV}"
DESCRIPTION="Library that allows you to use TrueType fonts in SDL applications"
HOMEPAGE="https://github.com/libsdl-org/SDL_ttf"
SRC_URI="https://github.com/libsdl-org/SDL_ttf/releases/download/release-${PV}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv sparc x86"
IUSE="+harfbuzz static-libs X"

# On bumps, check external/ for versions of bundled freetype + harfbuzz
# to crank up the dep bounds.
RDEPEND=">=media-libs/libsdl2-2.0.12[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.10.4[harfbuzz?,${MULTILIB_USEDEP}]
	virtual/opengl[${MULTILIB_USEDEP}]
	harfbuzz? ( >=media-libs/harfbuzz-2.8.0:=[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"

multilib_src_configure() {
	local mycmakeargs=(
		-DSDL2TTF_VENDORED=OFF
		-DSDL2TTF_HARFBUZZ=$(usex harfbuzz)
	)

	cmake_src_configure
}

multilib_src_install_all() {
	dodoc {CHANGES,README}.txt

	rm -rf "${ED}"/usr/share/licenses/ || die
}
