# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs

DESCRIPTION="Provides a virtual printer for CUPS to produce PDF files"
HOMEPAGE="https://www.cups-pdf.de/"
SRC_URI="https://www.cups-pdf.de/src/${PN}_${PV/_}.tar.gz"
S=${WORKDIR}/${PN}-${PV/_}

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="+ppds"

DEPEND="net-print/cups"

RDEPEND="${DEPEND}
	>=app-text/ghostscript-gpl-9.54"

PATCHES=( "${FILESDIR}"/${PN}-3.0.1-ghostscript-gpl-9.54-compat.patch )

src_compile() {
	pushd src &>/dev/null || die
	$(tc-getCC) ${LDFLAGS} ${CFLAGS} ${PN}.c -o ${PN} -lcups || die
	popd &>/dev/null || die
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
}
