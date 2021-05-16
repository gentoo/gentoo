# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Playlist handling library"
HOMEPAGE="http://libspiff.sourceforge.net/"
SRC_URI="mirror://sourceforge/libspiff/${P}.tar.bz2"

LICENSE="BSD LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/expat-2
	>=dev-libs/uriparser-0.7.5"
DEPEND="${RDEPEND}
	test? ( >=dev-util/cpptest-1.1 )"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-gcc44.patch
	"${FILESDIR}"/${P}-gcc47.patch
	"${FILESDIR}"/${P}-autotools.patch
)

src_prepare() {
	default
	eautoreconf
}

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
