# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P=SDL2_net-${PV}
inherit autotools multilib-minimal

DESCRIPTION="Simple Direct Media Layer Network Support Library"
HOMEPAGE="https://www.libsdl.org/projects/SDL_net/index.html"
SRC_URI="https://github.com/libsdl-org/SDL_net/releases/download/release-${PV}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc ~ppc64 ~riscv x86"
IUSE="static-libs"

RDEPEND=">=media-libs/libsdl2-2.0.4[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--disable-examples \
		$(use_enable static-libs static)
}

multilib_src_install() {
	emake DESTDIR="${D}" install
}

multilib_src_install_all() {
	dodoc {CHANGES,README}.txt
	find "${ED}" -name '*.la' -delete || die
}
