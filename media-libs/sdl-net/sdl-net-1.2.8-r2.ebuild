# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

MY_P="${P/sdl-/SDL_}"

DESCRIPTION="Simple Direct Media Layer Network Support Library"
HOMEPAGE="https://www.libsdl.org/projects/SDL_net/"
SRC_URI="https://www.libsdl.org/projects/SDL_net/release/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"

RDEPEND="media-libs/libsdl[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf --disable-gui
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
