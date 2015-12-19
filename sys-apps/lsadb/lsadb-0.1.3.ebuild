# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

DESCRIPTION="Prints out information on all devices attached to the ADB bus"
HOMEPAGE="http://pbbuttons.berlios.de/projects/lsadb/"
#SRC_URI="mirror://berlios/pub/pbbuttons/${PN}-${PV}.tgz"
SRC_URI="mirror://gentoo/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~ppc"
IUSE=""
DEPEND=""
RDEPEND="$DEPEND"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PN}-makefile.patch"
}

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	dobin lsadb
	doman lsadb.1
	dodoc README
}
