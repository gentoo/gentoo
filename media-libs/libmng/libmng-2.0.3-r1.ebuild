# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

DESCRIPTION="Multiple Image Networkgraphics lib (animated png's)"
HOMEPAGE="https://www.libmng.com/"
SRC_URI="https://downloads.sourceforge.net/libmng/${P}.tar.xz"

LICENSE="libmng"
SLOT="0/2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="lcms"

RDEPEND="
	>=virtual/zlib-1.2.8-r1:=[${MULTILIB_USEDEP}]
	>=virtual/jpeg-0-r2:0[${MULTILIB_USEDEP}]
	lcms? ( >=media-libs/lcms-2.5:2[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-jpeg-9a.patch )

src_prepare() {
	default
	# effect of 'make distclean'
	rm Makefile config.h config.log config.status libmng.pc stamp-h1 || die
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--disable-static \
		--with-jpeg \
		--without-lcms \
		$(use_with lcms lcms2)
}

multilib_src_install_all() {
	einstalldocs
	dodoc doc/{doc.readme,libmng.txt}

	doman doc/man/*.{3,5}

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
