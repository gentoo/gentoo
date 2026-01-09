# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A set of Java libraries providing Unicode and Globalization support"
HOMEPAGE="https://icu.unicode.org"
SRC_URI="https://github.com/unicode-org/icu/archive/release-${PV/_rc/rc}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/icu-release-${PV/_rc/rc}/icu4j/main"

LICENSE="icu"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

DEPEND="
	>=virtual/jdk-11:*
	test? (
		>=dev-java/gson-2.13.2:0
		dev-java/junitparams:0
	)
"

# Min java 11 because "as of release 10, 'var' is a restricted type name and
# cannot be used for type declarations or as the element type of an array"
# core/src/main/java/com/ibm/icu/impl/personname/PersonNameFormatterImpl.java:366: error: cannot find symbol
#             var unused = builder.setLocale(oldLocale);
#             ^
RDEPEND=">=virtual/jre-11:*"

DOCS=( ../../{CONTRIBUTING,README,SECURITY}.md )
HTML_DOCS=( ../{APIChangeReport,readme}.html )

src_prepare() {
	java-pkg-2_src_prepare
	# There was 1 failure:
	# 1) test(com.ibm.icu.dev.test.message2.CoreTest)
	# java.io.FileNotFoundException: Test data directory does not exist:
	# tried /var/tmp/portage/dev-java/icu4j-76.1/work/testdata/message2
	# and /var/tmp/portage/dev-java/icu4j-76.1/work/testdata/message2
	# 	at com.ibm.icu.dev.test.message2.TestUtils.getTestFile(TestUtils.java:212)
	# 	at com.ibm.icu.dev.test.message2.TestUtils.jsonReader(TestUtils.java:194)
	# 	at com.ibm.icu.dev.test.message2.CoreTest.test(CoreTest.java:52)
	cp -r ../..{,/..}/testdata || die
}

src_compile() {
	JAVA_GENTOO_CLASSPATH_EXTRA="icu4j.jar:icu4j-charset.jar"

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
		../tools/taglets/src/main/java
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

	einfo "Generating javadocs"
	JAVADOC_SRC_DIRS=(
		collate/src/main/java
		core/src/main/java
		currdata/src/main/java
		langdata/src/main/java
		regiondata/src/main/java
		translit/src/main/java
		charset/src/main/java
	)
	use doc && ejavadoc
}

src_test () {
	# TZ needed for some tests in com/ibm/icu/dev/test/format/DateFormatTest
	export LC_ALL="en_US.UTF-8" TZ="US/Pacific"

	JAVA_TEST_EXTRA_ARGS="-Djava.locale.providers=CLDR,COMPAT,SPI"
	JAVA_TEST_GENTOO_CLASSPATH="gson,junit-4,junitparams"

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
	# exclude invalid tests, not run by "mvn test"
	local JAVA_TEST_RUN_ONLY=$(find core/src/test/java \
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
		! -name "DefaultTestProperties.java" \
		! -name "MF2Test.java" \
		! -name "TestBoilerplate.java" \
		! -name "TestFunctionFactory.java" \
		-printf "%P\n" )
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	java-pkg-simple_src_test

	einfo "Creating core-tests.jar"
	jar cvf core-tests.jar -C target/test-classes . || die
	JAVA_GENTOO_CLASSPATH_EXTRA+=":core-tests.jar"
	JAVA_TEST_RUN_ONLY=()

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
}

src_install() {
	JAVA_JAR_FILENAME="icu4j.jar"
	JAVA_MAIN_CLASS="com.ibm.icu.util.VersionInfo"
	java-pkg-simple_src_install
	java-pkg_dojar "icu4j-charset.jar"

	if use source; then
		java-pkg_dosrc */src/main/java/*
	fi
}
