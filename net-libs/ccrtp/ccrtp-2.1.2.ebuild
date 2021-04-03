# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="GNU ccRTP - Implementation of the IETF real-time transport protocol"
HOMEPAGE="https://www.gnu.org/software/ccrtp/"
SRC_URI="mirror://gnu/ccrtp/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/2"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc static-libs"

RDEPEND="
	>=dev-libs/libgcrypt-1.2.3
	>=dev-libs/ucommon-6.3.1[cxx]"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

src_prepare() {
	default

	if ! use doc; then
		sed -i -e '/^SUBDIRS.*=/s#doc##' Makefile.am \
			-e 's#^doc/Makefile.##' configure.ac || die "sed failed"
	fi

	eautoreconf
}

src_configure() {
	econf --disable-demos --enable-static=$(usex static-libs) $(use_enable debug)
}

src_install() {
	default

	find "${ED}" -name '*.la' -type f -delete || die

	use doc && dodoc -r doc/html/
}
