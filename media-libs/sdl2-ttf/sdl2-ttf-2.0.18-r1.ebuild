# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

MY_P="SDL2_ttf-${PV}"
DESCRIPTION="Library that allows you to use TrueType fonts in SDL applications"
HOMEPAGE="https://www.libsdl.org/projects/SDL_ttf/"
SRC_URI="https://www.libsdl.org/projects/SDL_ttf/release/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="+harfbuzz static-libs X"

# On bumps, check external/ for versions of bundled freetype + harfbuzz
# to crank up the dep bounds.
RDEPEND=">=media-libs/libsdl2-2.0.12[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.10.4[harfbuzz?,${MULTILIB_USEDEP}]
	virtual/opengl[${MULTILIB_USEDEP}]
	harfbuzz? ( >=media-libs/harfbuzz-2.8.0:=[${MULTILIB_USEDEP}] )
	X? ( >=x11-libs/libXt-1.1.4[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

multilib_src_configure() {
	local myeconfargs=(
		--disable-freetype-builtin
		--disable-harfbuzz-builtin

		$(use_enable static-libs static)
		$(use_with X x)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	dodoc {CHANGES,README}.txt

	find "${ED}" -name '*.la' -delete || die
}
