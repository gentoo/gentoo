# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="The Simple Recursive Functions programming language"
HOMEPAGE="http://www.stratigery.com/srf.html"
SRC_URI="http://www.stratigery.com/srf.html/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-linux ~ppc-macos"
IUSE=""

DEPEND="
	sys-devel/flex
	virtual/yacc"
RDEPEND=""

src_prepare() {
	default
	# Remove CVS directory Bug#371821
	ecvs_clean
}

src_install() {
	dobin srf rfunc/rfunc
	doman srf.1
	dodoc README srf.html

	docinto examples
	dodoc examples/*
}
