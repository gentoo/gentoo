# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/scala/scala-3.3.20.ebuild,v 1.7 2015/02/28 19:15:33 monsieurp Exp $

EAPI=4

inherit autotools fortran-2

DESCRIPTION="Scale together multiple observations of reflections"
HOMEPAGE="http://www.ccp4.ac.uk/dist/html/scala.html"
SRC_URI="ftp://ftp.mrc-lmb.cam.ac.uk/pub/pre/${P}.tar.gz"

LICENSE="ccp4"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	!<sci-chemistry/ccp4-6.1.2
	!dev-java/scala-bin
	!dev-lang/scala
	sci-libs/ccp4-libs
	virtual/lapack"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	cp "${FILESDIR}"/{configure.ac,Makefile.am} "${S}"
	eautoreconf
}

src_install() {
	exeinto /usr/libexec/ccp4/bin/
	doexe ${PN}
	dosym ../libexec/ccp4/bin/${PN} /usr/bin/${PN}
	dodoc ${PN}.doc
	dohtml ${PN}.html
}
