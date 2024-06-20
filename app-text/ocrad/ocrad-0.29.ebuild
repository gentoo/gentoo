# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo unpacker toolchain-funcs

DESCRIPTION="OCR (Optical Character Recognition) program"
HOMEPAGE="https://www.gnu.org/software/ocrad/ocrad.html"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.lz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"

BDEPEND="$(unpacker_src_uri_depends)"

src_configure() {
	# ./configure is not based on autotools
	edo ./configure \
		CPPFLAGS="${CPPFLAGS}" \
		CXX="$(tc-getCXX)" \
		CXXFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		--prefix=/usr
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	default

	doman doc/${PN}.1
	doinfo doc/${PN}.info
}
