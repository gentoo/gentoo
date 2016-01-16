# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=5

JAVA_PKG_IUSE="source test"
inherit java-pkg-2 java-ant-2

DESCRIPTION="Java library and utilities for working with PDF documents"
HOMEPAGE="http://pdfbox.apache.org/"
ADOBE_FILES="pcfi-2010.08.09.jar"
SRC_URI="mirror://apache/${PN}/${PV}/${P}-src.zip
	http://repo2.maven.org/maven2/com/adobe/pdf/pcfi/2010.08.09/${ADOBE_FILES}"
LICENSE="BSD"
SLOT="1.8"
KEYWORDS="amd64 ppc64 x86"
IUSE=""

CDEPEND="dev-java/icu4j:4
	dev-java/junit:4
	dev-java/bcprov:1.45
	dev-java/bcmail:1.45
	>=dev-java/commons-logging-1.1.1:0"
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	test? (
		dev-java/ant-junit:0 )
	${CDEPEND}"

S="${WORKDIR}/${P}/${PN}"

JAVA_ANT_REWRITE_CLASSPATH="yes"

EANT_GENTOO_CLASSPATH="bcprov-1.45,bcmail-1.45,commons-logging,junit-4,icu4j-4"
EANT_BUILD_TARGET="pdfbox.package"
WANT_ANT_TASKS="ant-nodeps"

RESTRICT="test"

src_unpack() {
	unpack ${A}
}

java_prepare() {
	# This patch:
	# - turns off downloads
	# - increments version number (silly mistake from upstream)
	epatch "${FILESDIR}"/${P}-build.xml.patch
}

src_compile() {
	java-pkg-2_src_compile
	mv target/${P}.jar ${P}.jar
}

src_install() {
	java-pkg_newjar ${P}.jar ${PN}.jar

	if use source; then
		java-pkg_dosrc src/main/java/org
	fi
}
