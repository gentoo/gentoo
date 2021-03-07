# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_PN="pdfbox"
MY_P="${MY_PN}-${PV}"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="An open source Java library for parsing font files"
HOMEPAGE="https://pdfbox.apache.org/"
SRC_URI="mirror://apache/${MY_PN}/${PV}/${MY_P}-src.zip"
LICENSE="Apache-2.0"
SLOT="1.8"
KEYWORDS="amd64 ~arm64 ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

CDEPEND=">=dev-java/commons-logging-1.1.1:0"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.6
	app-arch/unzip
	test? ( dev-java/junit:4 )"

S="${WORKDIR}/${MY_P}/${PN}"
JAVA_SRC_DIR="src/main/java"
JAVA_GENTOO_CLASSPATH="commons-logging"

src_install() {
	java-pkg-simple_src_install
	dodoc README.txt
}

src_test() {
	local DIR=src/test/java
	local CP="${DIR}:${PN}.jar:$(java-pkg_getjars junit-4,${JAVA_GENTOO_CLASSPATH})"
	local TESTS=$(find ${DIR} -name "*Test.java")
	TESTS="${TESTS//src\/test\/java\/}"
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejavac -cp "${CP}" -d ${DIR} $(find ${DIR} -name "*.java")
	ejunit4 -classpath "${CP}" ${TESTS}
}
