# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PN="netty"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Async event-driven framework for high performance network applications"
HOMEPAGE="https://netty.io/"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/${MY_P}.Final.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

CDEPEND="dev-java/commons-logging:0
	dev-java/javassist:3
	dev-java/log4j:0
	dev-java/slf4j-api:0"

RDEPEND=">=virtual/jre-1.7
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.7
	${CDEPEND}
	test? (
		dev-java/asm:4
		dev-java/cglib:3
		dev-java/easymock:3.2
		dev-java/hamcrest-core:1.3
		dev-java/hamcrest-library:1.3
		dev-java/junit:4
		dev-java/mockito:0
		dev-java/objenesis:0
		dev-java/slf4j-simple:0
	)"

S="${WORKDIR}/${MY_PN}-${MY_P}.Final/${PN/${MY_PN}-}"
JAVA_SRC_DIR="src/main/java"
JAVA_GENTOO_CLASSPATH="commons-logging,javassist-3,log4j,slf4j-api"

java_prepare() {
	# Needs Mockito 1.10.
	rm -v src/test/java/io/netty/util/concurrent/PromiseCombinerTest.java || die
}

src_test() {
	cd src/test/java || die

	local CP=".:${S}/${PN}.jar:$(java-pkg_getjars --with-dependencies ${JAVA_GENTOO_CLASSPATH},asm-4,cglib-3,easymock-3.2,hamcrest-core-1.3,hamcrest-library-1.3,junit-4,mockito,objenesis,slf4j-simple)"
	local TESTS=$(find * -name "*Test.java")
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejavac -cp "${CP}" -d . $(find * -name "*.java")
	ejunit4 -classpath "${CP}" ${TESTS}
}
