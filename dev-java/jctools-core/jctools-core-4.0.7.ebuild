# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java Concurrency Tools Core Library"
HOMEPAGE="https://jctools.github.io/JCTools/"
SRC_URI="https://github.com/JCTools/JCTools/archive/v${PV}.tar.gz -> jctools-${PV}.tar.gz"
S="${WORKDIR}/JCTools-${PV}/jctools-core"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

DEPEND="
	>=dev-java/osgi-annotation-8.1.0:0
	>=virtual/jdk-11:*
	test? (
		>=dev-java/guava-testlib-33.5.0:0
		>=dev-java/guava-33.5.0:0
		>=dev-java/hamcrest-3.0:0
	)"

RDEPEND=">=virtual/jre-1.8:*"

DOCS=( ../{README,RELEASE-NOTES}.md )
PATCHES=( "${FILESDIR}/jctools-core-4.0.3-increase-TEST_TIMEOUT.patch" )

JAVA_CLASSPATH_EXTRA="osgi-annotation"
JAVA_INTERMEDIATE_JAR_NAME="org.${PN/-/.}"
JAVA_MODULE_INFO_OUT="src/main"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="guava guava-testlib hamcrest junit-4"
JAVA_TEST_SRC_DIR="src/test/java"

# Using the defaults of java-pkg-simple would skip more than half the number of tests.
src_test() {
	# org.jetbrains.kotlinx.lincheck is not yet packaged
	rm -r src/test/java/org/jctools/maps/linearizability_test || die
	# These tests would fail and are not run by "mvn test".
	# "org.jctools.queues.MpqSanityTest"
	# "org.jctools.queues.QueueSanityTest"
	# "org.jctools.queues.ScQueueRemoveTest"
	# "org.jctools.util.TestUtil"
	local TESTS=$(find src/test/java \
		\( -name "*Test*.java" \
		-o -name "nbsi_tester.java" \
		-o -name "nbhs_tester.java" \)\
		! -name "MpqSanityTest.java" \
		! -name "QueueSanityTest.java" \
		! -name "ScQueueRemoveTest.java" \
		! -name "TestUtil.java" \
		-printf '%P\n')
	TESTS="${TESTS//.java}"
	JAVA_TEST_RUN_ONLY="${TESTS//\//.}"
	java-pkg-simple_src_test
	# OK (8746 tests)
}
