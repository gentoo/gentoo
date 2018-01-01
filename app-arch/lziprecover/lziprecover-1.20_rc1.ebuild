# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Lziprecover is a data recovery tool and decompressor for lzip compressed files"
HOMEPAGE="http://www.nongnu.org/lzip/lziprecover.html"
SRC_URI="http://download.savannah.gnu.org/releases/lzip/${PN}/${P/_/-}.tar.gz
	http://download.savannah.gnu.org/releases-noredirect/lzip/${PN}/${P/_/-}.tar.gz"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${P/_/-}"

src_configure() {
	# not autotools-based
	./configure \
		--prefix="${EPREFIX}"/usr \
		CXX="$(tc-getCXX)" \
		CPPFLAGS="${CPPFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}" || die
}
