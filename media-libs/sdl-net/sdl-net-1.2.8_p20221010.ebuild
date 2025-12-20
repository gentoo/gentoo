# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Check SDL-1.2 branch for possible backports/new snapshots

inherit multilib-minimal

SDL_NET_COMMIT="091c95c031769f48d3ffaacddfdea1af999f4446"

MY_PN="${PN/sdl-/SDL_}"
DESCRIPTION="Simple Direct Media Layer Network Support Library"
HOMEPAGE="https://github.com/libsdl-org/SDL_net"
SRC_URI="https://github.com/libsdl-org/SDL_net/archive/${SDL_NET_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${MY_PN}-${SDL_NET_COMMIT}

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ppc ppc64 ~sparc x86"

RDEPEND="media-libs/libsdl[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf --disable-gui
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
