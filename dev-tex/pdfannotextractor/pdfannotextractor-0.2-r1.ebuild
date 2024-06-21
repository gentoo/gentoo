# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit latex-package java-pkg-2 java-ant-2

MY_COMMIT_ID=718e18be0c8fd1dc5b7c974eb4fbe6d0774cd05e
MY_PDFBOX_VER="1.8.17"
MY_FONTBOX_VER="1.7.1"

DESCRIPTION="Extract annotations from pdf files"
HOMEPAGE="https://www.ctan.org/tex-archive/macros/latex/contrib/pax/"
SRC_URI="
	https://github.com/bastien-roucaries/latex-pax/archive/${MY_COMMIT_ID}.tar.gz
		-> ${P}.tar.gz
	https://downloads.apache.org/pdfbox/${MY_PDFBOX_VER}/pdfbox-${MY_PDFBOX_VER}.jar
	https://archive.apache.org/dist/pdfbox/${MY_FONTBOX_VER}/fontbox-${MY_FONTBOX_VER}.jar
"

S="${WORKDIR}/latex-pax-${MY_COMMIT_ID}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86 ~x64-macos"

CP_DEPEND="
	dev-java/commons-logging:0
"
COMMON_DEPEND="virtual/latex-base"
DEPEND="
	${COMMON_DEPEND}
	>=virtual/jdk-11
"
BDEPEND="app-arch/unzip"
RDEPEND="
	${CP_DEPEND}
	${COMMIN_DEPEND}
	virtual/perl-Getopt-Long
	dev-perl/File-Which
	>=virtual/jre-11
	!<dev-texlive/texlive-latexextra-2023_p69752-r4
"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="
	commons-logging
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.2-javajars.patch
)

src_unpack() {
	unpack ${P}.tar.gz
}

src_prepare() {
	default
	cp "${DISTDIR}"/pdfbox-${MY_PDFBOX_VER}.jar pdfbox.jar || die
	cp "${DISTDIR}"/fontbox-${MY_FONTBOX_VER}.jar fontbox.jar || die
}

src_compile() {
	cd source || die
	EANT_GENTOO_CLASSPATH_EXTRA="${S}/pdfbox.jar:${S}/fontbox.jar" eant || die
}

src_install() {
	java-pkg_dojar scripts/pax.jar pdfbox.jar fontbox.jar
	java-pkg_dolauncher ${PN} --main pax.PDFAnnotExtractor

	insinto ${TEXMF}/latex/pax
	doins tex/pax.sty

	dodoc README
}
