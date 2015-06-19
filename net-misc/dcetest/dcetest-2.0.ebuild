# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/dcetest/dcetest-2.0.ebuild,v 1.7 2010/10/28 09:59:11 ssuominen Exp $

DESCRIPTION="dcetest is a clone of the Windows rpcinfo"
HOMEPAGE="http://www.atstake.com/research/tools/info_gathering/"
SRC_URI="http://www.atstake.com/research/tools/info_gathering/dcetest.tar"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc x86"
IUSE=""
DEPEND="sys-apps/sed"
RDEPEND=""
S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	# cleanup the makefile a little
	sed -e '/^CC/d' -i Makefile
	sed -e 's/CFLAGS.*/CFLAGS += -Wall -funsigned-char -fPIC/g' -i Makefile
}

src_compile() {
	emake || die
}

src_install() {
	dobin dcetest || die
	dodoc CHANGELOG README VERSION nt4sp6adefault.txt out out.txt out2.txt w2ksp0.txt
}
