# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A C++ library for polynomials over boolean rings"
HOMEPAGE="https://github.com/BRiAl/BRiAl"
SRC_URI="https://github.com/BRiAl/BRiAl/releases/download/${PV}/${P}.tar.bz2"

# The top-level license is GPL2+, but cudd/LICENSE is BSD.
LICENSE="BSD GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="png"

BDEPEND="virtual/pkgconfig"
DEPEND="dev-libs/boost
	sci-libs/m4ri[png=]"
RDEPEND="${DEPEND}"

src_configure() {
	tc-export PKG_CONFIG

	# with-boost-libdir added to deal with some rather quirky setups
	# see https://github.com/cschwan/sage-on-gentoo/issues/551
	econf \
		--with-boost="${ESYSROOT}"/usr \
		--with-boost-libdir="${ESYSROOT}"/usr/$(get_libdir)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
