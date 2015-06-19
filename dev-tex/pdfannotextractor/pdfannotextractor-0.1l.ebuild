# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/pdfannotextractor/pdfannotextractor-0.1l.ebuild,v 1.5 2013/06/25 16:56:32 ago Exp $

EAPI=3

inherit latex-package java-utils-2 java-pkg-2 java-ant-2 eutils

DESCRIPTION="Extract annotations from pdf files"
HOMEPAGE="http://www.ctan.org/tex-archive/macros/latex/contrib/pax/"
SRC_URI="mirror://gentoo/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~x64-macos"
IUSE=""

CDEPEND="virtual/latex-base
	dev-java/pdfbox
	dev-java/fontbox"
DEPEND="${CDEPEND}
	app-arch/unzip
	>=virtual/jdk-1.5"
RDEPEND="${CDEPEND}
	virtual/perl-Getopt-Long
	dev-perl/File-Which
	>=virtual/jre-1.5
	!<=dev-texlive/texlive-latexextra-2010"

TEXMF=/usr/share/texmf-site
S=${WORKDIR}

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="pdfbox fontbox"

src_prepare() {
	epatch "${FILESDIR}/javajars.patch"
	java-pkg-2_src_prepare
}

src_compile() {
	cd "${S}/source/latex/pax"
	eant || die
}

src_install() {
	newbin scripts/pax/pdfannotextractor.pl pdfannotextractor || die
	java-pkg_dojar "${S}/source/latex/pax/pax.jar" || die
	insinto ${TEXMF}
	doins -r tex || die
	dodoc doc/latex/pax/README || die
}
