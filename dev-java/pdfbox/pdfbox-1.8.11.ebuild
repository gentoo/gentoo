# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

BC_SLOT="1.45"
ADOBE_FILES="pcfi-2010.08.09.jar"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java library and utilities for working with PDF documents"
HOMEPAGE="http://pdfbox.apache.org/"
SRC_URI="mirror://apache/${PN}/${PV}/${P}-src.zip
	http://repo2.maven.org/maven2/com/adobe/pdf/pcfi/2010.08.09/${ADOBE_FILES}"
LICENSE="Apache-2.0"
SLOT="1.8"
KEYWORDS="amd64 ppc64 x86"
IUSE="test"
RESTRICT="test" # Explosive even when manually using unmodified build.xml.

CDEPEND="dev-java/fontbox:${SLOT}
	dev-java/jempbox:${SLOT}
	dev-java/bcmail:${BC_SLOT}
	dev-java/bcprov:${BC_SLOT}
	>=dev-java/commons-logging-1.1.1:0
	dev-java/icu4j:55"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.6
	app-arch/unzip
	test? ( dev-java/junit:4 )"

S="${WORKDIR}/${P}/${PN}"
JAVA_SRC_DIR="src/main/java"
JAVA_ENCODING="ISO-8859-1"
JAVA_GENTOO_CLASSPATH="fontbox-${SLOT},jempbox-${SLOT},bcmail-${BC_SLOT},bcprov-${BC_SLOT},commons-logging,icu4j-55"

src_unpack() {
	unpack ${P}-src.zip
}

java_prepare() {
	local DIR=target/classes/org/apache/${PN}/resources
	mkdir -p "${DIR}/afm" || die

	unzip -j -d "${DIR}" "${DISTDIR}/${ADOBE_FILES}" com/adobe/pdf/pcfi/glyphlist.txt || die
	unzip -j -d "${DIR}/afm" "${DISTDIR}/${ADOBE_FILES}" com/adobe/pdf/pcfi/afm/*.afm || die

	echo "${PN}.version=${PV}" > ${DIR}/${PN}.version || die
}

src_compile() {
	java-pkg-simple_src_compile
	java-pkg_addres ${PN}.jar src/main/resources
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dolauncher ${PN} --main org.apache.${PN}.PDFBox
}

src_test() {
	local DIR=src/test/java
	local CP="${DIR}:${PN}.jar:$(java-pkg_getjars junit-4,${JAVA_GENTOO_CLASSPATH})"
	local TESTS=$(find ${DIR} -name "*Test.java")
	TESTS="${TESTS//src\/test\/java\/}"
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejavac -encoding ${JAVA_ENCODING} -cp "${CP}" -d ${DIR} $(find ${DIR} -name "*.java")
	ejunit4 -classpath "${CP}" ${TESTS}
}
