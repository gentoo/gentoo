# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/lsadb/lsadb-0.1.3.ebuild,v 1.1 2009/11/30 20:14:31 josejx Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Prints out information on all devices attached to the ADB bus"
HOMEPAGE="http://pbbuttons.berlios.de/projects/lsadb/"
SRC_URI="mirror://berlios/pub/pbbuttons/${PN}-${PV}.tgz"
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
