# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV=${PV/./}
DESCRIPTION="pdfnup, pdfjoin and pdf90"
HOMEPAGE="http://www.warwick.ac.uk/go/pdfjam"
SRC_URI="http://www.warwick.ac.uk/go/pdfjam/${PN}_${MY_PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""
S="${WORKDIR}"/${PN}

DEPEND="virtual/latex-base"
RDEPEND="${DEPEND}"

src_install() {
	dobin bin/*
	dodoc PDFjam-README.html
	doman man1/*
}
