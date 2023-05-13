# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.ibm.icu:icu4j:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A set of Java libraries providing Unicode and Globalization support"
HOMEPAGE="https://icu.unicode.org"
SRC_URI="https://github.com/unicode-org/icu/archive/release-${PV/./-}.tar.gz -> icu-${PV}.tar.gz"
S="${WORKDIR}/icu-release-${PV/./-}/icu4j/main"

LICENSE="icu"
SLOT="70"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND=">=virtual/jdk-1.8:*
	test? ( dev-java/junitparams:0 )"

RDEPEND=">=virtual/jre-1.8:*"

HTML_DOCS=( ../{APIChangeReport,readme}.html )

PATCHES=(
	"${FILESDIR}/icu4j-73.2-DateFormatTest.patch"
)

JAVA_TEST_EXCLUDES=(
	# Invalid tests, not run by maven
	"com.ibm.icu.dev.data.TestDataElements_testtypes"
	"com.ibm.icu.dev.data.resources.TestDataElements_en_Latn_US"
	"com.ibm.icu.dev.data.resources.TestDataElements_en_US"
	"com.ibm.icu.dev.data.resources.TestDataElements_fr_Latn_FR"
	"com.ibm.icu.dev.data.resources.TestDataElements_te"
	"com.ibm.icu.dev.data.resources.TestMessages"
	"com.ibm.icu.dev.test.ModuleTest"
	"com.ibm.icu.dev.test.TestBoilerplate"
	"com.ibm.icu.dev.test.TestDataModule"
	"com.ibm.icu.dev.test.bidi.TestData"
	"com.ibm.icu.dev.test.calendar.ChineseTestCase"
	"com.ibm.icu.dev.test.calendar.TestCase"
	"com.ibm.icu.dev.test.format.ExhaustivePersonNameFormatterTest"
	"com.ibm.icu.dev.test.localespi.TestUtil"
	"com.ibm.icu.dev.test.message2.TestCase"
	"com.ibm.icu.dev.test.stringprep.TestData"
	"com.ibm.icu.dev.test.translit.TestUtility"
	# Maven: [INFO] Tests run: 364, Failures: 0, Errors: 0, Skipped: 0
	"com.ibm.icu.dev.test.serializable.CompatibilityTest" # Tests run: 364,  Failures: 4
	# Maven: [INFO] Tests run: 90, Failures: 0, Errors: 0, Skipped: 0
	"com.ibm.icu.dev.test.serializable.CoverageTest" # Tests run: 99,  Failures: 9
	# Following tests need to run separately:
	com.ibm.icu.dev.test.calendar.CalendarRegressionTest
	com.ibm.icu.dev.test.calendar.CompatibilityTest
	com.ibm.icu.dev.test.calendar.DataDrivenCalendarTest
	com.ibm.icu.dev.test.calendar.HolidayTest
	com.ibm.icu.dev.test.calendar.IndianTest
	com.ibm.icu.dev.test.calendar.IslamicTest
	com.ibm.icu.dev.test.calendar.JapaneseTest
	com.ibm.icu.dev.test.format.DataDrivenFormatTest
	com.ibm.icu.dev.test.format.DateFormatRegressionTest
	com.ibm.icu.dev.test.format.DateFormatRoundTripTest
	com.ibm.icu.dev.test.format.DateIntervalFormatTest
	com.ibm.icu.dev.test.format.DateTimeGeneratorTest
	com.ibm.icu.dev.test.format.TestMessageFormat
	com.ibm.icu.dev.test.message2.MessageFormat2Test
	com.ibm.icu.dev.test.message2.Mf2FeaturesTest
	com.ibm.icu.dev.test.message2.Mf2IcuTest
	com.ibm.icu.dev.test.timezone.TimeZoneBoundaryTest
	com.ibm.icu.dev.test.util.CurrencyTest
)
JAVA_TEST_EXTRA_ARGS="-Djava.locale.providers=CLDR,COMPAT,SPI"
JAVA_TEST_GENTOO_CLASSPATH="junit-4,junitparams"
JAVA_TEST_RESOURCE_DIRS=(
	tests/res/collate/src
	tests/res/core/src
	tests/res/translit/src
)
JAVA_TEST_SRC_DIR=(
	tests/charset/src
	tests/collate/src
	tests/core/src
	tests/localespi/src
	tests/packaging/src
	tests/translit/src
)

src_prepare() {
	default #780585
	java-pkg_clean ! -path "./shared/data/*" # keep icudata.jar, icutzdata.jar, testdata.jar
	java-pkg-2_src_prepare

	# java-pkg-simple.eclass wants resources in JAVA_RESOURCE_DIRS
	mkdir -p resources || die

	pushd classes > /dev/null || die
		find -type f \
			! -name '*.java' \
			! -name 'license.html' \
			| xargs cp --parent -t ../resources || die
	popd > /dev/null || die

	pushd resources/core/src > /dev/null || die
		# icudata and icutzdata for "icu4j.jar"
		jar -xf "${S}"/shared/data/icudata.jar || die
		jar -xf "${S}"/shared/data/icutzdata.jar || die
		# move these resources to "icu4j-charset.jar"
		mkdir -p "${S}"/resources/charset/src/com/ibm/icu/impl/data/icudt"$(ver_cut 1)"b || die
		mv com/ibm/icu/impl/data/icudt"$(ver_cut 1)"b/{*.cnv,cnvalias.icu} \
			"${S}"/resources/charset/src/com/ibm/icu/impl/data/icudt"$(ver_cut 1)"b || die

		# create 9 files com/ibm/icu/impl/data/icudt69b/*/fullLocaleNames.lst
		for dir in $(find com/ibm/icu/impl/data/icudt"$(ver_cut 1)"b/ -type d ! -name 'unit' -exec echo {} +); do
			ls -1 $dir/*.res | sed -e 's%.*\/%%' -e 's%\..*$%%' -e '/pool/d' -e '/res_index/d' -e '/tzdbNames/d'\
				> $dir/'fullLocaleNames.lst';
		done || die "fullLocaleNames.lst failed"
	popd > /dev/null || die

	if use test; then
		# initializationError(com.ibm.icu.dev.data.resources.TestDataElements)
		# but test_excluding it would kill tousands of other tests.
		mkdir -p tests/framework/src/com/ibm/icu/dev/data/resources || die
		mv tests/{core,framework}/src/com/ibm/icu/dev/data/resources/TestDataElements.java || die

		# Separate tests resources
		mkdir tests/res || die
		pushd tests > /dev/null || die
			find -type f \
				! -name '*.java' \
				| xargs cp --parent -t res || die
		popd > /dev/null || die

		cp -r ../tools/misc/{src,resources} || die
		find ../tools/misc/resources -type f -name '*.java' -exec rm -rf {} + || die
	fi
}

src_compile() {
	einfo "Compiling icu4j.jar"
	JAVA_AUTOMATIC_MODULE_NAME="com.ibm.icu"
	JAVA_JAR_FILENAME="icu4j.jar"
	JAVA_MAIN_CLASS="com.ibm.icu.util.VersionInfo"
	JAVA_RESOURCE_DIRS="resources/core/src"
	JAVA_SRC_DIR=(
		classes/collate/src
		classes/core/src
		classes/currdata/src
		classes/langdata/src
		classes/regiondata/src
		classes/translit/src
	)
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":icu4j.jar"
	rm -r target || die

	einfo "Compiling icu4j-charset.jar"
	JAVA_AUTOMATIC_MODULE_NAME="com.ibm.icu.charset"
	JAVA_JAR_FILENAME="icu4j-charset.jar"
	JAVA_MAIN_CLASS=""
	JAVA_RESOURCE_DIRS="resources/charset/src"
	JAVA_SRC_DIR=( classes/charset/src )
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":icu4j-charset.jar"
	rm -r target || die

	einfo "Compiling icu4j-localespi.jar"
	JAVA_AUTOMATIC_MODULE_NAME="com.ibm.icu.localespi"
	JAVA_JAR_FILENAME="icu4j-localespi.jar"
	JAVA_RESOURCE_DIRS="resources/localespi/src"
	JAVA_SRC_DIR=( classes/localespi/src )
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":icu4j-localespi.jar"
	rm -r target || die

	# main/test/framework
	# needed for compilicg the tests
	# but "No runnable methods" ("Invalid test class")
	if use test; then
		JAVA_JAR_FILENAME="framework.jar"
		JAVA_RESOURCE_DIRS=( tests/res/framework/src ../tools/misc/resources )
		JAVA_SRC_DIR=( tests/framework/src ../tools/misc/src )
		java-pkg-simple_src_compile
		rm -fr target || die
	fi

	# javadocs
	if use doc; then
		JAVA_JAR_FILENAME="ignoreme.jar"
		JAVA_SRC_DIR=( classes )
		java-pkg-simple_src_compile
	fi
}

src_test () {
	JAVA_GENTOO_CLASSPATH_EXTRA+=":framework.jar:shared/data/testdata.jar"

	JAVA_TEST_RUN_ONLY=(
		com.ibm.icu.dev.test.rbbi.AbstractBreakIteratorTests
		com.ibm.icu.dev.test.calendar.CalendarRegressionTest
		com.ibm.icu.dev.test.calendar.CompatibilityTest
		com.ibm.icu.dev.test.calendar.DataDrivenCalendarTest
		com.ibm.icu.dev.test.calendar.HolidayTest
		com.ibm.icu.dev.test.calendar.IndianTest
		com.ibm.icu.dev.test.calendar.IslamicTest
		com.ibm.icu.dev.test.calendar.JapaneseTest
		com.ibm.icu.dev.test.format.DataDrivenFormatTest
		com.ibm.icu.dev.test.format.DateFormatRegressionTest
		com.ibm.icu.dev.test.format.DateFormatRoundTripTest
		com.ibm.icu.dev.test.format.DateIntervalFormatTest
		com.ibm.icu.dev.test.format.DateTimeGeneratorTest
		com.ibm.icu.dev.test.format.TestMessageFormat
		com.ibm.icu.dev.test.message2.MessageFormat2Test
		com.ibm.icu.dev.test.message2.Mf2FeaturesTest
		com.ibm.icu.dev.test.message2.Mf2IcuTest
		com.ibm.icu.dev.test.timezone.TimeZoneBoundaryTest
		com.ibm.icu.dev.test.util.CurrencyTest
	)
	java-pkg-simple_src_test

	JAVA_TEST_RUN_ONLY=()
	# ../maven-build/maven-icu4j-localespi/pom.xml#L133-L143
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
