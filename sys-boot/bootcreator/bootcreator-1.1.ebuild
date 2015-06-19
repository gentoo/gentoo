# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/bootcreator/bootcreator-1.1.ebuild,v 1.4 2011/04/10 14:18:53 ulm Exp $

inherit eutils

DESCRIPTION="Simple generator for Forth based BootMenu scripts for Pegasos machines"

HOMEPAGE="http://tbs-software.com/morgoth/projects.html"
SRC_URI="http://tbs-software.com/morgoth/files/bootcreator-src.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc -*"
IUSE=""
DEPEND=""

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd ${S}
	mv examples/example.bc examples/bootmenu.example
}

src_compile() {
	cd ${S}
	make all || die "Can't compile bootmenu"
}

src_install() {
	cd ${S}
	dosbin src/bootcreator
	insinto /etc
	doins examples/bootmenu.example
	dodoc doc/README doc/COPYING
}
