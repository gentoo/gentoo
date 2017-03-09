# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="The Simple Recursive Functions programming language"
HOMEPAGE="http://www.stratigery.com/srf.html"
SRC_URI="http://www.stratigery.com/srf.html/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~x86-linux ~ppc-macos ~amd64"
IUSE=""

DEPEND="
	sys-devel/flex
	virtual/yacc"
RDEPEND=""

src_prepare() {
	# Remove CVS directory Bug#371821
	ecvs_clean
}

src_install() {
	dobin srf rfunc/rfunc
	doman srf.1
	dohtml srf.html
	dodoc README
	docinto examples
	dodoc examples/*
}
