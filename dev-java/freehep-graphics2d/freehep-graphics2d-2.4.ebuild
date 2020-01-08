# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CHARTABLE_PN="freehep-chartable-converter-plugin"
CHARTABLE_P="${CHARTABLE_PN}-2.2.1"

MY_PN="freehep-vectorgraphics"
MY_P="${MY_PN}-${PV}"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="High Energy Physics Java library - FreeHEP Graphics 2D Library"
HOMEPAGE="http://java.freehep.org/"
SRC_URI="https://github.com/freehep/${MY_PN}/archive/${MY_P}.tar.gz
	https://github.com/freehep/${CHARTABLE_PN}/archive/${CHARTABLE_P}.tar.gz"
LICENSE="Apache-2.0 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

CDEPEND="~dev-java/freehep-graphicsbase-${PV}:${SLOT}"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.7
	test? ( dev-java/junit:4 )"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.7"

S="${WORKDIR}/${MY_PN}-${MY_P}/${PN}"
JAVA_SRC_DIR="src/main/java"
JAVA_GENTOO_CLASSPATH="freehep-graphicsbase"

src_compile() {
	# This package uses a custom Maven plugin to generate some
	# sources. We're not using Maven but we can run it manually. We
	# could package the plugin separately but it's not used elsewhere.

	local SRC ENC CP="${WORKDIR}"/${CHARTABLE_PN}-${CHARTABLE_P}/src/main/java CLASS=org/freehep/graphics2d/font/encoding/CharTableConverter
	ejavac "${CP}/${CLASS}.java"

	for SRC in src/main/encoding/{Expert,Symbol,Zapfdingbats}.utf-16; do
		ebegin "Converting ${SRC}"
		java -cp "${CP}" ${CLASS} ${JAVA_SRC_DIR} org.freehep.graphics2d.font ${SRC} || die
		eend $?
	done

	SRC=src/main/encoding/Latin.utf-16

	for ENC in ISO MAC WIN PDF STD; do
		ebegin "Converting ${SRC} (${ENC})"
		java -cp "${CP}" ${CLASS} ${JAVA_SRC_DIR} org.freehep.graphics2d.font ${SRC} ${ENC} || die
		eend $?
	done

	java-pkg-simple_src_compile
}

src_test() {
	local DIR=src/test/java
	local CP="${DIR}:${PN}.jar:$(java-pkg_getjars junit-4,${JAVA_GENTOO_CLASSPATH})"
	local TESTS=$(find ${DIR} -name "Test*.java")
	TESTS="${TESTS//src\/test\/java\/}"
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejavac -cp "${CP}" -d ${DIR} $(find ${DIR} -name "*.java")
	ejunit4 -classpath "${CP}" ${TESTS}
}
