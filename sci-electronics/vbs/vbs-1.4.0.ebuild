# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils

HOMEPAGE="http://www.geda.seul.org/tools/vbs/index.html"
DESCRIPTION="vbs - the Verilog Behavioral Simulator"
SRC_URI="http://www.geda.seul.org/dist/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
IUSE="examples"
KEYWORDS="~amd64 ppc ~x86"

DEPEND=">=sys-devel/flex-2.3
	>=sys-devel/bison-1.22"
RDEPEND=""

S="${WORKDIR}/${P}/src"

src_prepare() {
	epatch "${FILESDIR}/${P}-gcc-4.1.patch"
	epatch "${FILESDIR}/${P}-gcc-4.3.patch"
	sed -i -e "s/strrchr(n,'.')/const_cast<char*>(strrchr(n,'.'))/" common/scp_tab.cc || die "sed failed"
}

src_compile() {
	emake -j1 vbs || die "Compilation failed"
}

src_install() {
	dobin vbs
	cd ..
	dodoc BUGS CHANGELOG* CONTRIBUTORS COPYRIGHT FAQ README vbs.txt
	if use examples ; then
		insinto /usr/share/${PF}/examples
		doins EXAMPLES/*
	fi
}
