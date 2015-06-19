# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/dinero/dinero-4.7-r1.ebuild,v 1.5 2013/03/30 15:03:18 ulm Exp $

EAPI=4

inherit autotools toolchain-funcs

MY_P="d${PV/./-}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Cache simulator"
HOMEPAGE="http://www.cs.wisc.edu/~markhill/DineroIV/"
SRC_URI="ftp://ftp.cs.wisc.edu/markhill/DineroIV/${MY_P}.tar.gz"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

src_prepare() {
	sed -e "s/\$(CC)/& \$(LDFLAGS)/" \
	  -i Makefile.in || die #331837
	eautoreconf
	tc-export AR
}

src_install() {
	dobin dineroIV
	dodoc CHANGES COPYRIGHT NOTES README TODO
}
