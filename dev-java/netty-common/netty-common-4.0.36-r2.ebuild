# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PN="netty"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Async event-driven framework for high performance network applications"
HOMEPAGE="https://netty.io/"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/${MY_P}.Final.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"
IUSE="test"

# Same test failures as before the revbumps still occur. See https://bugs.gentoo.org/827221
RESTRICT="test"

CP_DEPEND="dev-java/commons-logging:0
	dev-java/javassist:3
	dev-java/log4j-12-api:2
	dev-java/log4j-core:2
	dev-java/slf4j-api:0"

RDEPEND="${CP_DEPEND}
	virtual/jre:1.8"

# It does not build with java 11, https://bugs.gentoo.org/788364
# src/main/java/io/netty/util/internal/Cleaner0.java:44: error: cannot find symbol
#                Cleaner cleaner = (Cleaner) cleanerField.get(direct);
#                ^
#  symbol:   class Cleaner
#  location: class Cleaner0
DEPEND="${CP_DEPEND}
	virtual/jdk:1.8
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

src_prepare() {
	default
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
