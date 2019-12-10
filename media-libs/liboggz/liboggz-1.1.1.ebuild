# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Oggz provides a simple programming interface for reading and writing Ogg files and streams"
HOMEPAGE="https://www.xiph.org/oggz/"
SRC_URI="https://downloads.xiph.org/releases/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 sparc x86"
IUSE="doc static-libs test"
RESTRICT="!test? ( test )"

RDEPEND=">=media-libs/libogg-1.2.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	test? ( app-text/docbook-sgml-utils )"

PATCHES=( "${FILESDIR}/${P}-destdir.patch" )

src_prepare() {
	default

	if ! use doc; then
		sed -i -e '/AC_CHECK_PROG/s:doxygen:dIsAbLe&:' configure.ac || die
	fi

	AT_M4DIR="m4" eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die "Pruning failed"
}
