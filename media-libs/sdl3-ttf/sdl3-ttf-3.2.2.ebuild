# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

MY_P="SDL_ttf-release-${PV}"
DESCRIPTION="Library that allows you to use TrueType fonts in SDL applications"
HOMEPAGE="https://github.com/libsdl-org/SDL_ttf"
SRC_URI="https://github.com/libsdl-org/SDL_ttf/archive/refs/tags/release-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+harfbuzz +plutosvg static-libs X"

# On bumps, check external/ for versions of bundled freetype + harfbuzz
# to crank up the dep bounds.
RDEPEND="
	>=media-libs/libsdl3-3.2.10[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.13.2[harfbuzz?,${MULTILIB_USEDEP}]
	virtual/opengl[${MULTILIB_USEDEP}]
	harfbuzz? ( >=media-libs/harfbuzz-8.1.1:=[${MULTILIB_USEDEP}] )
	plutosvg? ( >=media-libs/plutosvg-0.0.6[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"

multilib_src_configure() {
	local mycmakeargs=(
		-DSDLTTF_VENDORED=OFF
		-DSDLTTF_INSTALL_MAN=ON
		-DSDLTTF_HARFBUZZ=$(usex harfbuzz)
		-DSDLTTF_PLUTOSVG=$(usex plutosvg)
	)

	cmake_src_configure
}

multilib_src_install_all() {
	dodoc CHANGES.txt README.md

	rm -rf "${ED}"/usr/share/licenses/ || die
}
