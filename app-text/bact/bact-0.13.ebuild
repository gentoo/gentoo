# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit toolchain-funcs

DESCRIPTION="Boosting Algorithm for Classification of Trees"
HOMEPAGE="http://chasen.org/~taku/software/bact/"
SRC_URI="http://chasen.org/~taku/software/bact/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
	emake CXX="$(tc-getCXX)" CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_test() {
	emake test
}

src_install() {
	dobin bact_learn bact_mkmodel bact_classify

	dohtml index.html bact.css
	dodoc README AUTHORS
}
