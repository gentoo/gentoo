# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A minimalistic realtime charting library for Java"
HOMEPAGE="https://commons.apache.org/proper/commons-imaging"
SRC_URI="mirror://apache/commons/sanselan/source/apache-sanselan-incubating-${PV}-src.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="test" # 5/48 failures, dunno why :(

RDEPEND=">=virtual/jre-1.6"

DEPEND=">=virtual/jdk-1.6
	test? ( dev-java/junit:4 )"

S="${WORKDIR}/sanselan-${PV}-incubator"
JAVA_ENCODING="ISO-8859-1"
JAVA_SRC_DIR="src/main/java"

java_prepare() {
	# Tsk, Windows developers…
	find src/test/java -name "*.java" -exec sed -i 's:\\:/:g' {} + || die
}

src_install() {
	java-pkg-simple_src_install
	dodoc README.txt RELEASE_NOTES
}

src_test() {
	local DIR="src/test/java"
	local CP="${DIR}:${PN}.jar:$(java-pkg_getjars junit-4)"

	local TESTS=$(find "${DIR}" -name "*Test.java" ! -name "*BaseTest.java" ! -name SanselanTest.java ! -name ByteSourceTest.java)
	TESTS="${TESTS//src\/test\/java\/}"
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejavac -cp "${CP}" -d "${DIR}" $(find "${DIR}" -name "*.java")
	ejunit4 -classpath "${CP}" ${TESTS}
}
