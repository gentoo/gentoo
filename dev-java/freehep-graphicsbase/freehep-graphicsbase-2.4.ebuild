# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_PN="freehep-vectorgraphics"
MY_P="${MY_PN}-${PV}"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="High Energy Physics Java library - FreeHEP Graphics Base Library"
HOMEPAGE="http://java.freehep.org/"
SRC_URI="https://github.com/freehep/${MY_PN}/archive/${MY_P}.tar.gz"
LICENSE="Apache-2.0 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

CDEPEND="dev-java/freehep-io:0
	dev-java/junit:4"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.7"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.7"

S="${WORKDIR}/${MY_PN}-${MY_P}/${PN}"
JAVA_SRC_DIR="src/main/java"
JAVA_GENTOO_CLASSPATH="freehep-io,junit-4"

src_compile() {
	java-pkg-simple_src_compile
	java-pkg_addres ${PN}.jar src/main/resources
}

src_test() {
	local DIR=src/test/java
	local CP="${DIR}:${PN}.jar:$(java-pkg_getjars ${JAVA_GENTOO_CLASSPATH})"
	local TESTS=$(find ${DIR} -name "*Test.java" ! -name "ExportFileTypeTest.java")
	TESTS="${TESTS//src\/test\/java\/}"
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejavac -cp "${CP}" -d ${DIR} $(find ${DIR} -name "*.java")
	ejunit4 -classpath "${CP}" ${TESTS}
}
