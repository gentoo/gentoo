# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/JCTools/JCTools/archive/v3.1.0.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild jctools-core-3.1.0.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.jctools:jctools-core:3.0.1"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java Concurrency Tools Core Library"
HOMEPAGE="https://jctools.github.io/JCTools/"
SRC_URI="https://github.com/JCTools/JCTools/archive/v${PV}.tar.gz -> jctools-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="3"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

# Compile dependencies
# POM: pom.xml
# test? com.google.guava:guava-testlib:21.0 -> >=dev-java/guava-testlib-30.1.1:0
# test? junit:junit:4.12 -> >=dev-java/junit-4.13.2:4
# test? org.hamcrest:hamcrest-all:1.3 -> !!!artifactId-not-found!!!

DEPEND=">=virtual/jdk-1.8:*
	test? (
		dev-java/guava-testlib:0
		dev-java/hamcrest-library:1.3
	)"

RDEPEND=">=virtual/jre-1.8:*"

DOCS=( ../{README,RELEASE-NOTES}.md )

S="${WORKDIR}/JCTools-${PV}/jctools-core"

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="guava-testlib,hamcrest-library-1.3,junit-4"
JAVA_TEST_SRC_DIR="src/test/java"

# Using the defaults of java-pkg-simple would skip more than half the number of tests.
src_test() {
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
}

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
