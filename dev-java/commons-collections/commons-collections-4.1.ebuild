# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

SLOT="4"
MY_P="${PN}${SLOT}-${PV}"

DESCRIPTION="Extends the JCF classes with new interfaces, implementations and utilities"
HOMEPAGE="https://commons.apache.org/collections/"
SRC_URI="mirror://apache/${PN/-//}/source/${MY_P}-src.tar.gz"
LICENSE="Apache-2.0"
KEYWORDS="amd64 ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	>=virtual/jdk-1.7
	test? (
		dev-java/easymock:3.2
		dev-java/junit:4
	)"

RDEPEND="
	>=virtual/jre-1.7"

S="${WORKDIR}/${MY_P}-src"

JAVA_SRC_DIR="src/main/java"

src_install() {
	java-pkg-simple_src_install
	dodoc RELEASE-NOTES.txt
	docinto html
	dodoc {DEVELOPERS-GUIDE,PROPOSAL}.html
}

src_test() {
	local DIR=src/test/java
	local CP="${DIR}:${DIR}/../resources:${PN}.jar:$(java-pkg_getjars easymock-3.2,junit-4)"
	local TESTS=$(find ${DIR} -name "*Test.java" ! -name "Abstract*" ! -name "BulkTest.*")
	TESTS="${TESTS//src\/test\/java\/}"
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejavac -cp "${CP}" -d ${DIR} $(find ${DIR} -name "*.java")
	ejunit4 -classpath "${CP}" ${TESTS}
}
