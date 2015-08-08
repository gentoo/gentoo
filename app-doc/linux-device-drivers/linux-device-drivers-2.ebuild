# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="howto write linux device drivers (updated for Linux 2.4)"
HOMEPAGE="http://www.oreilly.com/catalog/linuxdrive2/"
SRC_URI="http://www.xml.com/ldd/chapter/book/pdf/ldd_book_pdf.zip
	ftp://ftp.oreilly.com/examples/linuxdrive2/ldd2-samples-1.0.1.tar.gz"

LICENSE="FDL-1.1"
SLOT="2"
KEYWORDS="amd64 arm hppa ia64 ppc s390 x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}

src_install() {
	insinto /usr/share/doc/${PF}
	doins *.pdf || die "pdfs"
	insinto /usr/share/doc/${PF}/samples
	doins -r ldd2-samples-*/* || die "samples"
}
