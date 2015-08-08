# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit toolchain-funcs

DESCRIPTION="Provides a virtual printer for CUPS to produce PDF files"
HOMEPAGE="http://www.cups-pdf.de/"
SRC_URI="http://www.cups-pdf.de/src/${PN}_${PV/_}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="+ppds"

RDEPEND="net-print/cups
	app-text/ghostscript-gpl"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}-${PV/_}

src_compile() {
	pushd src >/dev/null
	$(tc-getCC) ${LDFLAGS} ${CFLAGS} ${PN}.c -o ${PN} -lcups || die
	popd >/dev/null
}

src_install() {
	exeinto /usr/libexec/cups/backend
	exeopts -m0700
	doexe src/cups-pdf

	insinto /etc/cups
	doins extra/cups-pdf.conf

	insinto /usr/share/cups/model
	if use ppds; then
		doins extra/CUPS-PDF_opt.ppd
	else
		doins extra/CUPS-PDF_noopt.ppd
	fi

	dodoc ChangeLog README

	dodoc -r contrib
}
