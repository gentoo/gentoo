# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=1
JAVA_PKG_IUSE="doc source"
WANT_ANT_TASKS="ant-nodeps"
inherit java-pkg-2 java-ant-2

MY_PN="PDFBox"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Java library and utilities for working with PDF documents"
HOMEPAGE="http://www.pdfbox.apache.org"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~x64-macos"
IUSE=""

CDEPEND="dev-java/fontbox:0
	dev-java/bcprov:1.38
	dev-java/bcmail:1.38
	dev-java/lucene:2.1
	dev-java/ant-core:0"
RDEPEND=">=virtual/jre-1.4
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${CDEPEND}"

JAVA_PKG_FILTER_COMPILER="jikes"
S="${WORKDIR}/${MY_P}"

# missing needed files
RESTRICT="test"

src_unpack() {
	unpack ${A}
	cd "${S}"

	rm -v external/*.jar lib/*.jar || die
	rm -rf docs/javadoc

	# the pdf files used in test cases are not included
	rm -rf src/test

	cd external
	java-pkg_jar-from fontbox
	java-pkg_jar-from bcprov-1.38
	java-pkg_jar-from bcmail-1.38
	java-pkg_jar-from lucene-2.1
	java-pkg_jar-from ant-core ant.jar
}

EANT_BUILD_TARGET="package"

my_launcher() {
	java-pkg_dolauncher ${1} --main org.pdfbox.${2}
	echo "${2} -> ${1}" >> "${T}"/launcher.list
}

src_install() {
	java-pkg_newjar lib/${MY_P}-dev.jar

	my_launcher pdfconvertcolorspace ConvertColorspace
	my_launcher pdfdecrypt Decrypt
	my_launcher pdfencrypt Encrypt
	my_launcher pdfexportfdf ExportFDF
	my_launcher pdfexportxfdf ExportXFDF
	my_launcher pdfextractimages ExtractImages
	my_launcher pdfextracttext ExtractText
	my_launcher pdfimportfdf ImportFDF
	my_launcher pdfimportxfdf ImportXFDF
	my_launcher pdfoverlay Overlay
	my_launcher pdfdebugger PDFDebugger
	my_launcher pdfmerger PDFMerger
	my_launcher pdfreader PDFReader
	my_launcher pdfsplit PDFSplit
	my_launcher pdftoimage PDFToImage
	my_launcher printpdf PrintPDF
	my_launcher texttopdf TextToPDF

	if use doc; then
		dohtml -r docs/*
		java-pkg_dojavadoc website/build/site/javadoc
	fi

	use source && java-pkg_dosrc src/org
}

pkg_postinst() {
	elog "This package installs several command line tools for manipulating"
	elog "PDF files. Some of their names were changed from upstream to"
	elog "be less ambigous, and not collide with other packages. For"
	elog "detailed information refer to the html documentation installed with"
	elog "USE=doc, or ${HOMEPAGE}"

	while read line
	do
		elog ${line}
	done < "${T}"/launcher.list
}
