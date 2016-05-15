# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit latex-package eutils

DESCRIPTION="Post-process presentations in PDF format which were prepared using (La)TeX to add dynamic effects"

# Taken from:
#SRC_URI="http://www.tex.ac.uk/tex-archive/support/ppower4/pp4sty.zip
#	http://www.tex.ac.uk/tex-archive/support/ppower4/pp4p.jar
#	http://www.tex.ac.uk/tex-archive/support/ppower4/ppower4
#	http://www.tex.ac.uk/tex-archive/support/ppower4/manual.pdf"
SRC_URI="mirror://gentoo/${P}.tar.gz"

HOMEPAGE="http://www.tex.ac.uk/tex-archive/support/ppower4/index.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 x86"

IUSE=""
DEPEND="app-arch/unzip"
RDEPEND="${DEPEND}
	virtual/jre"

src_unpack() {

	unpack ${A}
	cd "${S}"
	unzip pp4sty.zip

	epatch "${FILESDIR}/${PN}-gentoo.patch"
}

src_install() {

	latex-package_src_install || die

	dobin ppower4

	insinto /usr/lib/${PN}
	doins pp4p.jar

	insinto /usr/share/doc/${PF}
	doins manual.pdf
}
