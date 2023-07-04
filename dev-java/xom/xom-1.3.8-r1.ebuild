# Copyright 1999-2023 Gentoo Authors
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
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

# Bug #905215
PROPERTIES="test_network"
RESTRICT="test"

CP_DEPEND="
	dev-java/jaxen:1.2
	dev-java/xerces:2"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*"

DEPEND="
	${CP_DEPEND}
	dev-java/junit:0
	>=virtual/jdk-1.8:*"

PATCHES=( "${FILESDIR}/xom-1.3.7-disable-invalid-test.patch" )

JAVA_AUTOMATIC_MODULE_NAME="nu.xom"
JAVA_MAIN_CLASS="nu.xom.Info"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	java-pkg-2_src_prepare
	java-pkg_clean
	default

	# removing directories based on build.xml
	rm -rv XOM/src/nu/xom/benchmarks/ || die
	rm -rv XOM/src/nu/xom/integrationtests/ || die
	rm -rv XOM/src/nu/xom/samples/ || die
	rm -rv XOM/src/nu/xom/tools/ || die

	# reorganize the code and resources so that it goes well with java-pkg-simple
	mkdir -pv ${JAVA_SRC_DIR} ${JAVA_RESOURCE_DIRS} ${JAVA_TEST_SRC_DIR}/nu/xom || die
	mv -v {XOM/src,${JAVA_TEST_SRC_DIR}}/nu/xom/tests || die
	mv -v XOM/data . || die
	pushd XOM/src || die
	for file in $(find -type f -name "*.java"); do
		cp --parents -R ${file} "${WORKDIR}/${JAVA_SRC_DIR}" || die
	done
	for file in $(find -type f ! -name "*.java"); do
		cp --parents -R ${file} "${WORKDIR}/${JAVA_RESOURCE_DIRS}" || die
	done
	popd
}

src_test() {
	# These tests need to run separately, otherwise fail
	# Should pass with "OK (126 tests)"
	JAVA_TEST_RUN_ONLY=(
		nu.xom.tests.AttributesTest
		nu.xom.tests.DocumentTest
		nu.xom.tests.ElementTest
		nu.xom.tests.NodesTest
		nu.xom.tests.ParentNodeTest
	)
	java-pkg-simple_src_test

	JAVA_TEST_RUN_ONLY=()
	pushd src/test/java > /dev/null || die
		# Exclude EBCDICTest.java
		# https://github.com/elharo/xom/blob/v1.3.8/src/nu/xom/tests/EBCDICTest.java#L71-L73
		# And exclude those tests already run before
		local JAVA_TEST_RUN_ONLY=$(find * \
			-type f \
			-name "*Test.java" \
			! -name 'EBCDICTest.java' \
			! -name 'AttributesTest.java' \
			! -name 'DocumentTest.java' \
			! -name 'ElementTest.java' \
			! -name 'NodesTest.java' \
			! -name 'ParentNodeTest.java' \
			)
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	popd > /dev/null || die
	java-pkg-simple_src_test
}
