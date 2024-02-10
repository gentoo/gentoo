# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A minimalistic realtime charting library for Java"
HOMEPAGE="https://commons.apache.org/proper/commons-imaging/"
SRC_URI="https://archive.apache.org/dist/commons/sanselan/source/apache-sanselan-incubating-${PV}-src.tar.gz"
S="${WORKDIR}/sanselan-${PV}-incubator"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test" # 5/48 failures, dunno why :(

DEPEND=">=virtual/jdk-1.8:*
	test? ( dev-java/junit:4 )"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_ENCODING="ISO-8859-1"
JAVA_SRC_DIR="src/main/java"

src_prepare() {
	java-pkg-2_src_prepare
	# Tsk, Windows developers…
	find src/test/java -name "*.java" -exec sed -i 's:\\:/:g' {} + || die
}

src_test() {
	local DIR="src/test/java"
	local CP="${DIR}:${PN}.jar:$(java-pkg_getjars junit-4)"

	local TESTS=$(find "${DIR}" -name "*Test.java" \
		! -name "*BaseTest.java" ! -name SanselanTest.java ! -name ByteSourceTest.java)
	TESTS="${TESTS//src\/test\/java\/}"
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejavac -cp "${CP}" -d "${DIR}" $(find "${DIR}" -name "*.java")
	ejunit4 -classpath "${CP}" ${TESTS}
}
