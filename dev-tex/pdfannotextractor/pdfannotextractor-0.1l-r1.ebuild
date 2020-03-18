# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package java-pkg-2 java-ant-2

DESCRIPTION="Extract annotations from pdf files"
HOMEPAGE="http://www.ctan.org/tex-archive/macros/latex/contrib/pax/"
SRC_URI="mirror://gentoo/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc64 x86 ~x64-macos"

COMMON_DEPEND="virtual/latex-base
	dev-java/pdfbox:1.8
	dev-java/fontbox:1.7"

DEPEND="${COMMON_DEPEND}
	>=virtual/jdk-1.6"

BDEPEND="app-arch/unzip"

RDEPEND="${COMMIN_DEPEND}
	virtual/perl-Getopt-Long
	dev-perl/File-Which
	>=virtual/jre-1.6"

TEXMF=/usr/share/texmf-site

S="${WORKDIR}"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="
	pdfbox-1.8
	fontbox-1.7
"
src_prepare() {
	eapply "${FILESDIR}"/javajars.patch
	eapply "${FILESDIR}"/StringVisitor.java.patch
	eapply "${FILESDIR}"/PDFAnnotExtractor.java.patch
	default
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
