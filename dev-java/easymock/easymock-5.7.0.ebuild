# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple junit5

DESCRIPTION="Mock Objects for interfaces in JUnit tests by generating them on the fly"
HOMEPAGE="https://easymock.org/"
DMV="1.5"	# dexmaker isn't yet packaged
SRC_URI="https://github.com/${PN}/${PN}/archive/${P}.tar.gz
	https://repo1.maven.org/maven2/org/droidparts/dexmaker/dexmaker/${DMV}/dexmaker-${DMV}.jar"
S="${WORKDIR}/${PN}-${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

DEPEND="
	>=dev-java/byte-buddy-1.18.10:0
	dev-java/junit:4
	dev-java/junit:5
	dev-java/objenesis:0
	>=virtual/jdk-1.8:*
	test? (
		>=dev-java/asm-9.10.1:0
	)
"

RDEPEND=">=virtual/jre-1.8:*"

JAVA_CLASSPATH_EXTRA="byte-buddy junit-4 junit-5 objenesis"
JAVA_GENTOO_CLASSPATH_EXTRA="${DISTDIR}/dexmaker-${DMV}.jar"

# EasyMockListener needs testng for compilation and
# seems to be needed only for running with testng
JAVA_SRC_DIR=( core/src/main/java ! -name 'EasyMockListener.java' )
JAVA_TEST_GENTOO_CLASSPATH="asm byte-buddy junit-5"
JAVA_TEST_SRC_DIR="core/src/test/java"

src_prepare() {
	java-pkg-2_src_prepare
	mkdir -p core/src/test/java/org/tests || die
	mv core/src/test/java/org/{easymock/,}tests/ReifiedMockSupportTest.java || die
}

src_install() {
	JAVA_SRC_DIR=( core/src/main/java )
	java-pkg-simple_src_install
}
