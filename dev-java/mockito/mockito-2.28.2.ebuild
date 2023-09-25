# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.mockito:mockito-core:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Mockito mock objects library core API and implementation"
HOMEPAGE="https://github.com/mockito/mockito"
SRC_URI="https://github.com/mockito/mockito/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="MIT"
SLOT="2"
KEYWORDS="amd64 ~arm ~arm64 ppc64 x86"

CP_DEPEND="
	dev-java/asm:9
	dev-java/byte-buddy:0
	dev-java/objenesis:0
"

DEPEND="
	dev-java/junit:4
	dev-java/opentest4j:0
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
	test? ( dev-java/assertj-core:3 )
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

# see https://bugs.gentoo.org/903897
PATCHES=( "${FILESDIR}/mockito-2.28.2-skip-failing-tests.patch" )

JAVA_AUTOMATIC_MODULE_NAME="org.mockito"
JAVA_CLASSPATH_EXTRA="junit-4 opentest4j"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_EXCLUDES=(
	org.mockito.internal.junit.JUnitRuleTest # We run it in JAVA_TEST_RUN_ONLY
	org.mockito.internal.util.reflection.DummyClassForTests # No runnable methods
	org.mockito.internal.util.reflection.DummyParentClassForTests # No runnable methods
	org.mockito.junit.TestableJUnitRunner # No runnable methods
	org.mockitoutil.TestBase #  No runnable methods
)
JAVA_TEST_GENTOO_CLASSPATH="assertj-core-3,junit-4"
JAVA_TEST_RUN_ONLY=(
	# This needs to run separately, otherwise one of its 4 tests would fail.
	org.mockito.internal.junit.JUnitRuleTest
)
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	java-pkg-2_src_prepare
	default
	# dev-java/byte-buddy is built from byte-buddy-dep without shaded stuff.
	sed \
		-e 's:net.bytebuddy.jar.asm:org.objectweb.asm:' \
		-i src/main/java/org/mockito/internal/creation/bytebuddy/MockMethodAdvice.java \
		-i src/main/java/org/mockito/internal/creation/bytebuddy/InlineBytecodeGenerator.java || die
}

src_compile() {
	java-pkg-simple_src_compile
	mv target/classes/org/mockito/internal/creation/bytebuddy/inject/MockMethodDispatcher.{class,raw} || die
	jar ufv mockito.jar -C target/classes org/mockito/internal/creation/bytebuddy/inject/MockMethodDispatcher.raw || die
}

src_test() {
	# Increasing number of test failures with higher Java versions
	# Test failures are documented in https://bugs.gentoo.org/903897
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge 11; then
		JAVA_TEST_EXCLUDES+=(
			org.mockito.internal.stubbing.defaultanswers.ReturnsMocksTest
			org.mockitousage.bugs.GenericsMockitoAnnotationsTest
		)
	fi
	if ver_test "${vm_version}" -ge 17; then
		JAVA_TEST_EXCLUDES+=(
			org.concurrentmockito.ThreadsRunAllTestsHalfManualTest
			org.mockitousage.matchers.InvalidUseOfMatchersTest
			org.mockitousage.serialization.DeepStubsSerializableTest
			org.mockitousage.stubbing.StubbingWithDelegateTest
		)
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.io=ALL-UNNAMED )
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.lang=ALL-UNNAMED )
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/sun.reflect.generics.reflectiveObjects=ALL-UNNAMED )
	fi
	# First run what needs to run separately
	java-pkg-simple_src_test
	# And then the other tests
	JAVA_TEST_RUN_ONLY=""
	java-pkg-simple_src_test
}
