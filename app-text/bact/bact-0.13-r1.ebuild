# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils toolchain-funcs

DESCRIPTION="Boosting Algorithm for Classification of Trees"
HOMEPAGE="http://chasen.org/~taku/software/bact/"
SRC_URI="http://chasen.org/~taku/software/bact/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-cpp14.patch" # bug #594312
)

HTML_DOCS=(
	index.html
	bact.css
)

src_compile() {
	emake CXX="$(tc-getCXX)" CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_test() {
	emake test
}

src_install() {
	dobin bact_learn bact_mkmodel bact_classify
	einstalldocs
}
