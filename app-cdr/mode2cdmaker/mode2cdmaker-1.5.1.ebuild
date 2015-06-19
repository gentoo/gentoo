# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/mode2cdmaker/mode2cdmaker-1.5.1.ebuild,v 1.6 2014/08/10 02:14:18 patrick Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Utility to create mode-2 CDs, for example XCDs"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="mirror://gentoo/${P}-src.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_compile() {
	tc-export CC
	emake -f Makefile.linux || die
}

src_install() {
	dobin mode2cdmaker || die
	dodoc {bugs,compatibility,readme}.txt
}
