# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.jctools:jctools-core:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java Concurrency Tools Core Library"
HOMEPAGE="https://jctools.github.io/JCTools/"
SRC_URI="https://github.com/JCTools/JCTools/archive/v${PV}.tar.gz -> jctools-${PV}.tar.gz"
S="${WORKDIR}/JCTools-${PV}/jctools-core"

LICENSE="Apache-2.0"
SLOT="3"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND="
	dev-java/osgi-annotation:0
	>=virtual/jdk-1.8:*
	test? (
		dev-java/guava-testlib:0
		dev-java/hamcrest:0
	)"

RDEPEND=">=virtual/jre-1.8:*"

DOCS=( ../{README,RELEASE-NOTES}.md )
PATCHES=( "${FILESDIR}/jctools-core-4.0.3-increase-TEST_TIMEOUT.patch" )

JAVA_AUTOMATIC_MODULE_NAME="org.jctools.core"
JAVA_CLASSPATH_EXTRA="osgi-annotation"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="guava-testlib,hamcrest,junit-4"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
}

# Using the defaults of java-pkg-simple would skip more than half the number of tests.
src_test() {
	# org.jetbrains.kotlinx.lincheck is not yet packaged
	rm -r src/test/java/org/jctools/maps/linearizability_test || die
	# These tests would fail and are not run by "mvn test".
	# "org.jctools.queues.MpqSanityTest"
	# "org.jctools.queues.QueueSanityTest"
	# "org.jctools.queues.ScQueueRemoveTest"
	# "org.jctools.util.TestUtil"
	pushd src/test/java || die
		local JAVA_TEST_RUN_ONLY=$(find * \
			\( -name "*Test*.java" \
			-o -name "nbsi_tester.java" \
			-o -name "nbhs_tester.java" \)\
			! -name "MpqSanityTest.java" \
			! -name "QueueSanityTest.java" \
			! -name "ScQueueRemoveTest.java" \
			! -name "TestUtil.java" \
			)
	popd
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	java-pkg-simple_src_test
	# OK (8746 tests)
}
