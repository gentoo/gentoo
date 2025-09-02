# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_COMMIT="9780596000080"
MY_PN="ldd2-samples"
MY_PV="1.0.1"

DESCRIPTION="Howto write linux device drivers (updated for Linux 2.4)"
HOMEPAGE="https://www.oreilly.com/catalog/linuxdrive2/"
SRC_URI="
	https://resources.oreilly.com/examples/${EGIT_COMMIT}/-/blob/master/${MY_PN}-${MY_PV}.tar.gz
	https://www.xml.com/ldd/chapter/book/pdf/ldd_book_pdf.zip
"
S="${WORKDIR}"

LICENSE="FDL-1.1"
SLOT="2"
KEYWORDS="amd64 arm ~hppa ppc ~s390 x86"

BDEPEND="app-arch/unzip"

src_install() {
	dodoc *.pdf
	docinto samples
	dodoc -r ldd2-samples-*/.
	docompress -x /usr/share/doc/${PF}
}
