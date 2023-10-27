# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_PROVIDES="
	com.ibm.icu:icu4j:${PV}
	com.ibm.icu:icu4j-charset:${PV}
	com.ibm.icu:icu4j-localespi:${PV}
"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A set of Java libraries providing Unicode and Globalization support"
HOMEPAGE="https://icu.unicode.org"
SRC_URI="https://github.com/unicode-org/icu/archive/release-${PV/./-}.tar.gz -> icu-${PV}.tar.gz"
S="${WORKDIR}/icu-release-${PV/./-}/icu4j/main"

LICENSE="icu"
SLOT="70"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND="
	>=virtual/jdk-1.8:*
	test? ( dev-java/junitparams:0 )
"

RDEPEND=">=virtual/jre-1.8:*"

DOCS=( ../../{CONTRIBUTING,README,SECURITY}.md )
HTML_DOCS=( ../{APIChangeReport,readme}.html )

src_prepare() {
	default
	java-pkg-2_src_prepare
}

src_compile() {
	JAVA_GENTOO_CLASSPATH_EXTRA="icu4j.jar:icu4j-charset.jar:icu4j-localespi.jar"

	einfo "Compiling icu4j.jar"
	JAVA_AUTOMATIC_MODULE_NAME="com.ibm.icu"
	JAVA_JAR_FILENAME="icu4j.jar"
	JAVA_MAIN_CLASS="com.ibm.icu.util.VersionInfo"
	JAVA_RESOURCE_DIRS=(
		collate/src/main/resources
		core/src/main/resources
		currdata/src/main/resources
		langdata/src/main/resources
		regiondata/src/main/resources
		translit/src/main/resources
	)
	JAVA_SRC_DIR=(
		collate/src/main/java
		core/src/main/java
		currdata/src/main/java
		langdata/src/main/java
		regiondata/src/main/java
		translit/src/main/java
	)
	java-pkg-simple_src_compile
	rm -r target || die

	einfo "Compiling icu4j-charset.jar"
	JAVA_AUTOMATIC_MODULE_NAME="com.ibm.icu.charset"
	JAVA_JAR_FILENAME="icu4j-charset.jar"
	JAVA_MAIN_CLASS=""
	JAVA_RESOURCE_DIRS=( charset/src/main/resources )
	JAVA_SRC_DIR=( charset/src/main/java )
	java-pkg-simple_src_compile
	rm -r target || die

	einfo "Compiling icu4j-localespi.jar"
	JAVA_AUTOMATIC_MODULE_NAME="com.ibm.icu.localespi"
	JAVA_JAR_FILENAME="icu4j-localespi.jar"
	JAVA_RESOURCE_DIRS=( localespi/src/main/resources )
	JAVA_SRC_DIR=( localespi/src/main/java )
	java-pkg-simple_src_compile
	rm -r target || die

	# javadocs
	if use doc; then
		einfo "Compiling javadocs"
		JAVA_JAR_FILENAME="ignoreme.jar"
		JAVA_SRC_DIR=(
			collate/src/main/java
			core/src/main/java
			currdata/src/main/java
			langdata/src/main/java
			regiondata/src/main/java
			translit/src/main/java
			charset/src/main/java
			localespi/src/main/java
		)
		java-pkg-simple_src_compile
	fi
}

src_test () {
	# TZ needed for some tests in com/ibm/icu/dev/test/format/DateFormatTest
	export LC_ALL="en_US.UTF-8" TZ="US/Pacific"

	JAVA_TEST_EXTRA_ARGS="-Djava.locale.providers=CLDR,COMPAT,SPI"
	JAVA_TEST_GENTOO_CLASSPATH="junit-4,junitparams"

	einfo "Compiling framework-tests.jar"
	JAVA_AUTOMATIC_MODULE_NAME="com.ibm.icu.framework"
	JAVA_JAR_FILENAME="framework-tests.jar"
	JAVA_MAIN_CLASS="com.ibm.icu.dev.test.TestAll"
	JAVA_RESOURCE_DIRS=( framework/src/test/resources )
	JAVA_SRC_DIR=( framework/src/test/java )
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":framework-tests.jar"

	einfo "Testing core aka icu4j.jar"
	JAVA_TEST_RESOURCE_DIRS="core/src/test/resources"
	JAVA_TEST_SRC_DIR="core/src/test/java"
	pushd "${JAVA_TEST_SRC_DIR}" || die
		# exclude invalid tests, not run by "mvn test"
		local JAVA_TEST_RUN_ONLY=$(find * \
			-name "*Test*.java" \
			! -name "ChineseTestCase.java" \
			! -name "DataDrivenNumberFormatTestUtility.java" \
			! -name "*Helper.java" \
			! -name "ModuleTest.java" \
			! -name "*Sample.java" \
			! -name "TestCase.java" \
			! -name "*TestData*.java" \
			! -name "*TestFmwk.java" \
			! -name "TestMessages.java" \
			! -name "TestUtils.java" \
			)
	popd
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	java-pkg-simple_src_test

	einfo "Creating core-tests.jar"
	jar cvf core-tests.jar -C target/test-classes .
	JAVA_GENTOO_CLASSPATH_EXTRA+=":core-tests.jar"
	JAVA_TEST_RUN_ONLY=""

	einfo "Testing collate"
	JAVA_TEST_RESOURCE_DIRS="collate/src/test/resources"
	JAVA_TEST_SRC_DIR="collate/src/test/java"
	java-pkg-simple_src_test

	einfo "Testing translit"
	JAVA_TEST_EXCLUDES=(
		# Invalid test classes, No runnable methods
		com.ibm.icu.dev.test.TestBoilerplate
		com.ibm.icu.dev.test.translit.TestUtility
	)
	JAVA_TEST_RESOURCE_DIRS="translit/src/test/resources"
	JAVA_TEST_SRC_DIR="translit/src/test/java"
	java-pkg-simple_src_test

	einfo "Testing charset"
	JAVA_TEST_RESOURCE_DIRS=""
	JAVA_TEST_SRC_DIR="charset/src/test/java"
	java-pkg-simple_src_test

	einfo "Testing common_tests"
	# "mvn test" runs only 90 tests here, Gentoo runs 99 but 9 of them fail.
	# coverage tests fail because test handlers for the parametrized tests
	# are not defined so the tests are broken and cannot succeed
	JAVA_TEST_EXCLUDES=( com.ibm.icu.dev.test.serializable.CoverageTest )
	JAVA_TEST_RESOURCE_DIRS=""
	JAVA_TEST_SRC_DIR="common_tests/src/test/java"
	java-pkg-simple_src_test

	einfo "Testing localespi"
	JAVA_TEST_RESOURCE_DIRS=""
	JAVA_TEST_SRC_DIR="localespi/src/test/java"
	# Invalid test classes, No runnable methods
	JAVA_TEST_EXCLUDES=( com.ibm.icu.dev.test.localespi.TestUtil )
	# https://bugs.gentoo.org/827212, "mvn test" does not run it at all
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if [[ "${vm_version}" != "1.8" ]] ; then
		java-pkg-simple_src_test
	fi
}

src_install() {
	default
	java-pkg_dojar "icu4j.jar"
	java-pkg_dojar "icu4j-charset.jar"
	java-pkg_dojar "icu4j-localespi.jar"

	if use doc; then
		java-pkg_dojavadoc target/api
	fi
	if use source; then
		java-pkg_dosrc "classes"
	fi
}
