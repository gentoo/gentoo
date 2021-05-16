# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker toolchain-funcs

DESCRIPTION="GNU Ocrad is an OCR (Optical Character Recognition) program"
HOMEPAGE="https://www.gnu.org/software/ocrad/ocrad.html"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.lz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"

DEPEND="$(unpacker_src_uri_depends)"

DOCS="AUTHORS ChangeLog NEWS README"

src_configure() {
	# ./configure is not based on autotools
	./configure \
		CPPFLAGS="${CPPFLAGS}" \
		CXX="$(tc-getCXX)" \
		CXXFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		--prefix=/usr || die
}

src_install() {
	default
	doman doc/${PN}.1
	doinfo doc/${PN}.info
}
