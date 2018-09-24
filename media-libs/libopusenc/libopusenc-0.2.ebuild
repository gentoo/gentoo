# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="High-level API for encoding .opus files"
HOMEPAGE="https://www.opus-codec.org/"
SRC_URI="https://archive.mozilla.org/pub/opus/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE="doc"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	doc? ( app-doc/doxygen[dot] )
"
RDEPEND="
	>=media-libs/opus-1.1
"

src_configure() {
	local myeconfargs=(
		$(use_enable doc)
	)

	econf "${myeconfsargs[@]}"
}

src_install() {
	default
	find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die
}
