# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

DESCRIPTION="A limited problem scanner for C source files"
HOMEPAGE="http://www.striker.ottawa.on.ca/~aland/pscan/"
# I wish upstream would version their files, even if it's only with a date
SRC_URI="http://www.striker.ottawa.on.ca/~aland/pscan/pscan.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

# Does NOT contain a testsuite, but does contain a test.c that confuses src_test
RESTRICT="test"

RDEPEND=""
DEPEND="${RDEPEND}
	sys-devel/flex"

S="${WORKDIR}/${PN}"

src_compile() {
	emake CC="$(tc-getCC) ${CFLAGS}" || die
}

src_install() {
	newbin pscan printf-scan || die
	dodoc README find_formats.sh test.c wu-ftpd.pscan || die
}
