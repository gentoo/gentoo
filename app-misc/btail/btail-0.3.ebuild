# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit toolchain-funcs

DESCRIPTION="Bayesian logfile filter"
HOMEPAGE="http://www.vanheusden.com/btail/"
SRC_URI="${HOMEPAGE}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="sys-libs/gdbm"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i Makefile \
		-e '/^LDFLAGS/s:=:+=:g' \
		-e '/$(CC)/s:-Wall:$(CFLAGS) &:g' \
		|| die
	sed -i conf.cpp \
		-e '/Configline/s:):, line):g' \
		|| die
}

src_compile() {
	emake \
		CFLAGS="${CFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)"
}

src_install() {
	dobin blearn btail
	dodoc readme.txt btail.conf license.txt
}
