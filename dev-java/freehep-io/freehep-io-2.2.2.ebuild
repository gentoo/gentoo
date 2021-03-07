# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="High Energy Physics Java library - FreeHEP I/O Library"
HOMEPAGE="http://java.freehep.org/"
SRC_URI="https://github.com/freehep/${PN}/archive/${P}.tar.gz"
LICENSE="Apache-2.0 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND=">=virtual/jdk-1.7
	test? ( dev-java/junit:4 )"

RDEPEND=">=virtual/jre-1.7"

S="${WORKDIR}/${PN}-${P}"
JAVA_SRC_DIR="src/main/java"

src_test() {
	local DIR=src/test/java
	local CP="${DIR}:${PN}.jar:$(java-pkg_getjars junit-4)"
	local TESTS=$(find ${DIR} -name "*Test.java" ! -name "Abstract*")
	TESTS="${TESTS//src\/test\/java\/}"
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejavac -cp "${CP}" -d ${DIR} $(find ${DIR} -name "*.java")
	ejunit4 -classpath "${CP}" ${TESTS}
}
