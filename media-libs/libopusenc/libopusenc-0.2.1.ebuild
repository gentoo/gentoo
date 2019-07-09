# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="High-level API for encoding .opus files"
HOMEPAGE="https://www.opus-codec.org/"
SRC_URI="https://archive.mozilla.org/pub/opus/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="doc"

BDEPEND="virtual/pkgconfig"
RDEPEND=">=media-libs/opus-1.1:="
DEPEND="
	${RDEPEND}
	doc? ( app-doc/doxygen[dot] )"

src_configure() {
	econf \
		--enable-shared \
		--disable-static \
		$(use_enable doc)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
