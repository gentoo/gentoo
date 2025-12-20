# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multilib-minimal

MY_P="${P/sdl-/SDL_}"
DESCRIPTION="Graphics drawing primitives library for SDL"
HOMEPAGE="https://www.ferzkopp.net/joomla/content/view/19/14/"
SRC_URI="https://www.ferzkopp.net/Software/SDL_gfx-2.0/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="ZLIB"
SLOT="0/16" # libSDL_gfx.so.16
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86"
IUSE="doc cpu_flags_x86_mmx"

RDEPEND=">=media-libs/libsdl-1.2.15-r4[video,${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -i -e 's/-O //' configure.in || die
	mv configure.{in,ac} || die
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable cpu_flags_x86_mmx mmx)
}

multilib_src_install_all() {
	einstalldocs

	if use doc ; then
		docinto html
		dodoc -r Docs/*
	fi

	find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die
}
