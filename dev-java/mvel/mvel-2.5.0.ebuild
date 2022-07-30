# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.mvel:mvel2:${PV}.Final"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="MVFLEX Expression Language"
HOMEPAGE="https://github.com/mvel/mvel"
SRC_URI="https://github.com/mvel/mvel/archive/mvel2-${PV}.Final.tar.gz"
S="${WORKDIR}/${PN}-${PN}2-${PV}.Final"

LICENSE="Apache-2.0"
SLOT="2.5"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND="
	dev-java/asm:9
	>=virtual/jdk-1.8:*
"
RDEPEND=">=virtual/jre-1.8:*"

# Required due to use of '_' as identifiers in source files
JAVADOC_ARGS="-source 8"
JAVA_CLASSPATH_EXTRA="asm-9"
JAVA_MAIN_CLASS="org.mvel2.sh.Main"
JAVA_SRC_DIR="src/main/java"

# Significantly speed up test execution
# https://github.com/mvel/mvel/blob/mvel2-2.3.2.Final/pom.xml#L158-L171
JAVA_TEST_EXTRA_ARGS=(
	-Dfile.encoding=UTF-8
	-Dmvel.disable.jit=true
	-Dmvel.tests.quick=true
)
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_RESOURCE_DIRS=( "src/test/resources" )
JAVA_TEST_SRC_DIR="src/test/java"

src_test() {
	# ${S}/pom.xml#201-214
	pushd src/test/java || die
		local JAVA_TEST_RUN_ONLY=$(find * \
			\( -name "*Test.java" \
			-o -name '*Tests.java' \
			-o -name 'UsageDemos.java' \)\
			! -name "AbstractTest.java*" \
			! -name "CompiledUnitTestEx.java" \
			! -name "PerfTest.java" \
			! -name "DroolsTest.java" \
			! -name "FailureTests.java" \
			! -name "PerformanceTest.java" \
			! -name "CompiledPerformanceTests.java" \
			! -name "MVELThreadTest.java*" \
			! -name "SimpleTests.java*" \
			! -name "BaseOperatorsTest.java*" \
			)
	popd
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	java-pkg-simple_src_test
}
