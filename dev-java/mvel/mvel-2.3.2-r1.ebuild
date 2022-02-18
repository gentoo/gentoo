# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.mvel:mvel2:2.3.2.Final"

# Note: This package has a mixture of JUnit 3 and JUnit 4 tests, all of which
# can be run with JUnit 4.  As of January 2022, JUnit 3 test launcher will only
# run 2 tests out of nearly 1100 JUnit 3 tests in total, whereas JUnit 4 test
# launcher can run all of them
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="MVFLEX Expression Language"
HOMEPAGE="https://github.com/mvel/mvel"
SRC_URI="https://github.com/mvel/mvel/archive/refs/tags/mvel2-${PV}.Final.tar.gz"

LICENSE="Apache-2.0"
SLOT="2.3"
KEYWORDS="amd64 ~arm ~arm64 ppc64 x86"

DEPEND="
	>=virtual/jdk-1.8:*
"

RDEPEND="
	>=virtual/jre-1.8:*
"

S="${WORKDIR}/${PN}-${PN}2-${PV}.Final"

JAVA_SRC_DIR="src/main/java"
# Required due to use of '_' as identifiers in source files
JAVADOC_ARGS="-source 8"
# https://github.com/mvel/mvel/blob/mvel2-2.3.2.Final/pom.xml#L131
JAVA_MAIN_CLASS="org.mvel2.sh.Main"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS=( "src/test/resources" )
JAVA_TEST_EXCLUDES=(
	# No runnable methods
	org.mvel2.tests.perftests.CompiledPerformanceTests
	org.mvel2.tests.perftests.SimpleTests
	org.mvel2.tests.core.MVELThreadTest
	org.mvel2.tests.core.res.TestClass
	org.mvel2.tests.core.res.TestInterface
	org.mvel2.tests.core.res.TestMVEL197
	org.mvel2.tests.templates.tests.res.TestPluginNode
)
# Significantly speed up test execution
# https://github.com/mvel/mvel/blob/mvel2-2.3.2.Final/pom.xml#L158-L171
JAVA_TEST_EXTRA_ARGS=(
	-Dfile.encoding=UTF-8
	-Dmvel.disable.jit=true
	-Dmvel.tests.quick=true
)

pkg_setup() {
	java-pkg-2_pkg_setup
	# Fix org.mvel2.tests.core.PropertyAccessTests.testMVEL308 failure
	# on Java 17, caused by java.lang.reflect.InaccessibleObjectException:
	# module java.base does not "opens java.util" to unnamed module
	# https://github.com/mvel/mvel/issues/282
	ver_test "$(java-config -g PROVIDES_VERSION)" -ge 17 && \
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.util=ALL-UNNAMED )
}

src_prepare() {
	# Clean up bundled JARs "manually" to prevent
	# removal of JARs under JAVA_TEST_RESOURCE_DIRS
	rm -r lib/ || die "Failed to remove bundled JARs"

	eapply "${FILESDIR}/${P}-update-supported-java-versions.patch"
	eapply "${FILESDIR}/${P}-update-version-in-output.patch"
	use test && eapply "${FILESDIR}/${P}-ignore-failing-tests.patch"
	java-pkg-2_src_prepare
}
