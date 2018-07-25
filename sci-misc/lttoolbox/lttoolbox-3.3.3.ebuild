# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic

DESCRIPTION="Toolbox for lexical processing, morphological analysis and generation of words"
HOMEPAGE="https://www.apertium.org"
SRC_URI="mirror://sourceforge/apertium/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND="dev-libs/libxml2:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# bug 619446
	append-cxxflags -std=c++14

	econf $(use_enable static-libs static)
}
