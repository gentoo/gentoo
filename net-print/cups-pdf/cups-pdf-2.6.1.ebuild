# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/cups-pdf/cups-pdf-2.6.1.ebuild,v 1.6 2014/08/10 20:35:52 slyfox Exp $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="Provides a virtual printer for CUPS to produce PDF files"
HOMEPAGE="http://www.cups-pdf.de/"
SRC_URI="http://www.cups-pdf.de/src/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="net-print/cups
	app-text/ghostscript-gpl"
RDEPEND="${DEPEND}"

src_compile() {
	cd "${S}"/src
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o ${PN} ${PN}.c || die "Compilation failed."
}

src_install () {
	exeinto /usr/libexec/cups/backend
	exeopts -m0700
	doexe src/cups-pdf

	insinto /usr/share/cups/model
	doins extra/CUPS-PDF.ppd

	insinto /etc/cups
	doins extra/cups-pdf.conf

	dodoc ChangeLog README
	newdoc contrib/Contents contrib_Contents
}

pkg_postinst () {
	elog "Please view both the README and contrib_Contents files"
	elog "as you may want to adjust some settings and/or use"
	elog "contributed software. In the latter case you may need"
	elog "to extract some files from the ${P} distfile."
}
