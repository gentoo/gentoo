# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools multilib-minimal

MY_P="SDL2_ttf-${PV}"
DESCRIPTION="library that allows you to use TrueType fonts in SDL applications"
HOMEPAGE="http://www.libsdl.org/projects/SDL_ttf/"
SRC_URI="http://www.libsdl.org/projects/SDL_ttf/release/${MY_P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs X"

RDEPEND="X? ( >=x11-libs/libXt-1.1.4[${MULTILIB_USEDEP}] )
	>=media-libs/libsdl2-2.0.1-r1[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.5.0.1[${MULTILIB_USEDEP}]
	virtual/opengl[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/sdl-ttf-2.0.11-freetype_pkgconfig.patch"
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
		$(use_with X x)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	dodoc {CHANGES,README}.txt
	find "${ED}" -name '*.la' -delete || die
}
