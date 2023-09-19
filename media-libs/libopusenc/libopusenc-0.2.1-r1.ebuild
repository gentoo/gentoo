# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="High-level API for encoding .opus files"
HOMEPAGE="https://www.opus-codec.org/"
SRC_URI="https://archive.mozilla.org/pub/opus/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc ppc64 ~riscv x86"
IUSE="doc"

RDEPEND=">=media-libs/opus-1.1:="
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.2.1-clang16.patch
)

src_prepare() {
	default

	# Should be able to drop in next release if patches merged
	eautoreconf
}

src_configure() {
	econf \
		--enable-shared \
		$(use_enable doc)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
