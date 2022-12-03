# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Check SDL-1.2 branch for possible backports/new snapshots

inherit multilib-minimal

SDL_TTF_COMMIT="2648c22c4f9e32d05a11b32f636b1c225a1502ac"

MY_PN="${PN/sdl-/SDL_}"
DESCRIPTION="Library that allows you to use TrueType fonts in SDL applications"
HOMEPAGE="https://github.com/libsdl-org/SDL_ttf"
SRC_URI="https://github.com/libsdl-org/SDL_ttf/archive/${SDL_TTF_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${MY_PN}-${SDL_TTF_COMMIT}

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE="static-libs X"

RDEPEND="
	>=media-libs/libsdl-1.2.15-r4[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.5.0.1[${MULTILIB_USEDEP}]
	X? ( >=x11-libs/libXt-1.1.4[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
		$(use_with X x)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	dodoc CHANGES README

	if ! use static-libs ; then
		find "${ED}" \( -name '*.a' -o -name '*.la' \) -delete || die
	fi
}
