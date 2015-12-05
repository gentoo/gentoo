# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit latex-package java-pkg-2 java-ant-2 eutils

DESCRIPTION="Extract annotations from pdf files"
HOMEPAGE="http://www.ctan.org/tex-archive/macros/latex/contrib/pax/"
SRC_URI="mirror://gentoo/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd ~x64-macos"
IUSE=""

CDEPEND="virtual/latex-base
	dev-java/pdfbox:1.8
	dev-java/fontbox:1.7"

DEPEND="${CDEPEND}
	app-arch/unzip
	>=virtual/jdk-1.6"

RDEPEND="${CDEPEND}
	virtual/perl-Getopt-Long
	dev-perl/File-Which
	>=virtual/jre-1.6
	!<=dev-texlive/texlive-latexextra-2010"

TEXMF=/usr/share/texmf-site
S="${WORKDIR}"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="
	pdfbox-1.8
	fontbox-1.7
"

PATCHES=(
	"${FILESDIR}/javajars.patch"
	"${FILESDIR}/PDFAnnotExtractor.java.patch"
	"${FILESDIR}/StringVisitor.java.patch"
)

java_prepare() {
	java-pkg_clean
	epatch "${PATCHES[@]}"
}

src_compile() {
	cd "${S}/source/latex/pax" || die
	eant || die
}

src_install() {
	newbin scripts/pax/pdfannotextractor.pl pdfannotextractor
	java-pkg_dojar "${S}/source/latex/pax/pax.jar"
	insinto ${TEXMF}
	doins -r tex
	dodoc doc/latex/pax/README
}
