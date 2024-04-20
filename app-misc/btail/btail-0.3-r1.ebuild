# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Bayesian logfile filter"
HOMEPAGE="https://www.vanheusden.com/btail/"
SRC_URI="https://www.vanheusden.com/btail/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="sys-libs/gdbm"
RDEPEND="${DEPEND}"

src_prepare() {
	default
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
