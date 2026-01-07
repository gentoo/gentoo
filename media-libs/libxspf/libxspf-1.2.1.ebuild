# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Playlist handling library"
HOMEPAGE="https://libspiff.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/libspiff/${P}.tar.bz2"

LICENSE="BSD LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/expat-2
	>=dev-libs/uriparser-0.7.5"
DEPEND="${RDEPEND}
	test? ( >=dev-util/cpptest-1.1 )"
BDEPEND="virtual/pkgconfig"

src_configure() {
	econf \
		--disable-doc \
		--disable-static \
		$(use_enable test)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
