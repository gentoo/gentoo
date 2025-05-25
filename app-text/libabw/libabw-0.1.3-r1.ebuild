# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Library parsing abiword documents"
HOMEPAGE="https://wiki.documentfoundation.org/DLP/Libraries/libabw"
SRC_URI="https://dev-www.libreoffice.org/src/${PN}/${P}.tar.xz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ppc64 ~riscv x86"
IUSE="doc"

BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen )
"
RDEPEND="
	dev-libs/librevenge
	dev-libs/libxml2:=
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	dev-libs/boost
	dev-build/libtool
"

src_configure() {
	local myeconfargs=( $(use_with doc docs) )
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
