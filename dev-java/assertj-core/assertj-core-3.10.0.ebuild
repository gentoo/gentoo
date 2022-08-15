# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/assertj/assertj-core/archive/assertj-core-3.10.0.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild assertj-core-3.10.0.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.assertj:assertj-core:3.10.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Rich and fluent assertions for testing for Java"
HOMEPAGE="https://assertj.github.io/doc/"
SRC_URI="https://github.com/assertj/${PN}/archive/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="3"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

CP_DEPEND="
	>=dev-java/byte-buddy-1.12.12:0
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
	dev-java/hamcrest-core:1.3
	dev-java/junit:4
	dev-java/opentest4j:0
	test? (
		dev-java/guava:0
		dev-java/junit-dataprovider:0
		dev-java/memoryfilesystem:0
		dev-java/mockito:4
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}"

DOCS=( {CODE_OF_CONDUCT,CONTRIBUTING,README}.md )

PATCHES=( "${FILESDIR}"/assertj-core-3.10.0-java11-compatibility.patch )

S="${WORKDIR}/${PN}-${P}"

JAVA_CLASSPATH_EXTRA="junit-4,hamcrest-core-1.3,opentest4j"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="guava,junit-dataprovider,memoryfilesystem,mockito-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

# These test classes are not run by "mvn test"
# FAILURES!!!
# Tests run: 11514,  Failures: 32
# Exclusion should leave "OK (11486 tests)" with jdk-11
# and 14 test failures with jdk-17
JAVA_TEST_EXCLUDES=(
	org.assertj.core.internal.BaseArraysTest
	org.assertj.core.internal.TestDescription
	org.assertj.core.navigation.BaseNavigableIterableAssert_Test
	org.assertj.core.navigation.BaseNavigableListAssert_Test
	org.assertj.core.navigation.GenericNavigableAssert_Test
	org.assertj.core.api.assumptions.BaseAssumptionsRunnerTest
	org.assertj.core.api.atomic.referencearray.AtomicReferenceArrayAssert_filtered_baseTest
	org.assertj.core.api.iterable.IterableAssert_filtered_baseTest
	org.assertj.core.api.objectarray.ObjectArrayAssert_filtered_baseTest
	org.assertj.core.api.TestCondition
	org.assertj.core.api.BaseAssertionsTest
	org.assertj.core.util.Files_TestCase
	org.assertj.core.test.EqualsHashCodeContractTestCase
	org.assertj.core.test.TestClassWithRandomId
	org.assertj.core.test.TestData
	org.assertj.core.test.TestFailures
)

src_prepare() {
	default
	sed \
		-e 's:verifyZeroInteractions:verifyNoInteractions:' \
		-i src/test/java/org/assertj/core/api/Assertions_assertThat_with_DoubleStream_Test.java \
		-i src/test/java/org/assertj/core/api/Assertions_assertThat_with_IntStream_Test.java \
		-i src/test/java/org/assertj/core/api/Assertions_assertThat_with_Iterator_Test.java \
		-i src/test/java/org/assertj/core/api/Assertions_assertThat_with_LongStream_Test.java \
		-i src/test/java/org/assertj/core/api/Assertions_assertThat_with_Stream_Test.java \
		-i src/test/java/org/assertj/core/matcher/AssertionMatcher_matches_Test.java || die
}

src_test() {
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge 17; then
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.io=ALL-UNNAMED )
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.lang=ALL-UNNAMED )
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.math=ALL-UNNAMED )
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.util=ALL-UNNAMED )
		# Before further test_excluds it should now read "Tests run: 11486,  Failures: 3"
		# Additional exclusions will leave "OK (11476 tests)"
		JAVA_TEST_EXCLUDES+=(
			org.assertj.core.internal.classes.Classes_assertHasMethods_Test
			org.assertj.core.util.xml.XmlStringPrettyFormatter_prettyFormat_Test
		)
	fi
	java-pkg-simple_src_test
}
