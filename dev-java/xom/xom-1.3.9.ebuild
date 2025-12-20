# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"
MAVEN_ID="xom:xom:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="XML Object Model"
HOMEPAGE="https://xom.nu"
SRC_URI="https://github.com/elharo/${PN}/releases/download/v${PV}/${P}-src.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64 ~x64-macos"

# Bug #905215 Without 'test_network',there are 14 test failures like:
#java.net.UnknownHostException: raw.githubusercontent.com
#java.net.UnknownHostException: www.cafeconleche.org
#java.net.UnknownHostException: www.ibiblio.org
#java.net.UnknownHostException: www.rsc.org
#java.net.UnknownHostException: www.w3.org
PROPERTIES="test_network"
RESTRICT="test"

CP_DEPEND="
	dev-java/jaxen:1.2
	dev-java/xerces:2
"

# Test compilation errors with Java 25, https://bugs.gentoo.org/951494
DEPEND="
	${CP_DEPEND}
	<=virtual/jdk-21:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_AUTOMATIC_MODULE_NAME="nu.xom"
JAVA_MAIN_CLASS="nu.xom.Info"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	java-pkg-2_src_prepare

	# reorganize the code and resources so that it goes well with java-pkg-simple
	mkdir -pv ${JAVA_SRC_DIR} ${JAVA_RESOURCE_DIRS} ${JAVA_TEST_SRC_DIR}/nu/xom || die
	mv -v {XOM/src,${JAVA_TEST_SRC_DIR}}/nu/xom/tests || die
	mv -v XOM/data . || die
	pushd XOM/src || die
		find -type f -name '*.java' ! -path '*/benchmarks/*' ! -path '*/integrationtests/*' ! -path '*/samples/*' \
			! -path '*/tools/*' | xargs cp --parents -t ../../src/main/java || die "copy sources"
		find -type f ! -name '*.java' ! -path '*/benchmarks/*' ! -path '*/samples/*' ! -path '*/tools/*' |
			xargs cp --parents -t ../../src/main/resources || die
	popd
}

src_test() {
	JAVA_TEST_RUN_ONLY=( nu.xom.tests.XOMTests )	# OK (1421 tests)
	JAVA_TEST_RUN_ONLY+=( nu.xom.tests.MegaTest )	# excluded in XOMTests.java
	java-pkg-simple_src_test
}
