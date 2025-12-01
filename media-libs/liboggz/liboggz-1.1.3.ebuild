# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A simple programming interface for reading and writing Ogg files and streams"
HOMEPAGE="https://www.xiph.org/oggz/"
SRC_URI="https://downloads.xiph.org/releases/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc x86"
IUSE="debug doc test"
RESTRICT="!test? ( test )"

DEPEND=">=media-libs/libogg-1.2.0"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen )
	test? ( app-text/docbook-sgml-utils )
"

src_prepare() {
	default

	if ! use doc; then
		sed -e '/AC_CHECK_PROG/s:doxygen:dIsAbLe&:' -i configure.ac || die
	fi

	AT_M4DIR="m4" eautoreconf
}

src_configure() {
	econf $(use_enable debug)
}

src_install() {
	default
	find "${D}" -type f -name '*.la' -delete || die
}
