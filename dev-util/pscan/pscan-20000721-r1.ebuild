# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A limited problem scanner for C source files"
HOMEPAGE="http://www.striker.ottawa.on.ca/~aland/pscan/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""
# Does NOT contain a testsuite, but does contain a test.c that confuses src_test
RESTRICT="test"

BDEPEND="sys-devel/flex"

S="${WORKDIR}/${PN}"
PATCHES=( "${FILESDIR}"/${P}-fix-build-system.patch )

src_configure() {
	tc-export CC
}

src_install() {
	newbin pscan printf-scan
	dodoc README find_formats.sh test.c wu-ftpd.pscan
}
