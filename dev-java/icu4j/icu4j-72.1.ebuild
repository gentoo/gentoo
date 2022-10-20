# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/unicode-org/icu/archive/release-72-1.tar.gz --slot 70 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild icu4j-72.1.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.ibm.icu:icu4j:72.1"
JAVA_TESTING_FRAMEWORKS="junit-4"
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/icu.asc

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="A set of Java libraries providing Unicode and Globalization support"
HOMEPAGE="https://icu.unicode.org"
SRC_URI="https://github.com/unicode-org/icu/archive/refs/tags/release-${PV/./-}.tar.gz -> icu-${PV}.tar.gz
	https://github.com/unicode-org/icu/releases/download/release-${PV/./-}/SHASUM512.txt.asc"

LICENSE="icu"
SLOT="70"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND=">=virtual/jdk-1.8:*
	test? ( dev-java/junitparams:0 )"

RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}/icu-release-${PV/./-}/icu4j/main"

HTML_DOCS=( ../{APIChangeReport,license,readme}.html )

JAVA_GENTOO_CLASSPATH_EXTRA="icu4j.jar:icu4j-charset.jar:icu4j-localespi.jar:testdata.jar:framework.jar"
JAVA_TEST_GENTOO_CLASSPATH="junit-4,junitparams"
JAVA_TEST_EXTRA_ARGS="-Djava.locale.providers=CLDR,COMPAT,SPI"

JAVA_TEST_SRC_DIR=(
	tests/charset/src
	tests/collate/src
	tests/core/src
#	tests/framework/src # we compile it in src_compile
	tests/localespi/src
	tests/packaging/src
	tests/translit/src
)

JAVA_TEST_RESOURCE_DIRS=(
	tests/charset/resources
	tests/collate/resources
	tests/core/resources
#	tests/framework/resources
	tests/localespi/resources
	tests/packaging/resources
	tests/translit/resources
)

JAVA_TEST_EXCLUDES=(
	"com.ibm.icu.dev.data.TestDataElements_testtypes" # Invalid test class 1. No runnable methods
	"com.ibm.icu.dev.data.resources.TestDataElements_en_Latn_US" # Invalid test class 1. No runnable methods
	"com.ibm.icu.dev.data.resources.TestDataElements_en_US" # Invalid test class 1. No runnable methods
	"com.ibm.icu.dev.data.resources.TestDataElements_fr_Latn_FR" # Invalid test class 1. No runnable methods
	"com.ibm.icu.dev.data.resources.TestDataElements_te" # Invalid test class 1. No runnable methods
	"com.ibm.icu.dev.data.resources.TestMessages" # Invalid test class 1. No runnable methods
	"com.ibm.icu.dev.test.translit.TestUtility" # Invalid test class 1. No runnable methods
	"com.ibm.icu.dev.test.localespi.TestUtil" # Invalid test class 1. No runnable methods
	"com.ibm.icu.dev.test.stringprep.TestData" # Invalid test class 1. No runnable methods
	"com.ibm.icu.dev.test.calendar.ChineseTestCase" # Invalid test class 1. Test class should have exactly one public zero-argument constructor
	"com.ibm.icu.dev.test.calendar.TestCase" # java.lang.IllegalArgumentException: Test class can only have one constructor
	"com.ibm.icu.dev.test.bidi.TestData" # Invalid test class 1. Test class should have exactly one public constructor
	# following kills 98 tests and and avoids 9 test failures
	# coverage tests fail because test handlers for the parametrized tests are not defined so the tests are broken and cannot succeed
	"com.ibm.icu.dev.test.serializable.CoverageTest"
)

src_prepare() {
	default

	# create the resources directories
	mkdir resources || die
	cp -r classes/* resources || die

	# remove .java files from resources
	find resources -type f -name '*.java' -exec rm -rf {} + || die "deleting classes failed"

	# this should not go in the jar files
	mv shared/licenses/license.html .. || die

	# icudata and icutzdata for "icu4j.jar"
	pushd resources/core/src || die
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
	popd

	# this test class was failing with "No runnable methods"
	# but test_excluding it would kill tousands of other tests.
	mkdir -p tests/framework/src/com/ibm/icu/dev/data/resources || die
	mv tests/{core,framework}/src/com/ibm/icu/dev/data/resources/TestDataElements.java || die

	# testdata.jar needs to be on classpath
	cp shared/data/testdata.jar . || die

	# clone tests src
	for i in charset collate core framework localespi packaging translit; do
		cp -r tests/$i/{src,resources};
		done || die "copying tests from src to resources failed"
	cp -r ../tools/misc/{src,resources} || die

	# separate tests resources from tests src
	find tests/*/resources -type f -name '*.java' -exec rm -rf {} + || die
	find ../tools/misc/resources -type f -name '*.java' -exec rm -rf {} + || die
}

src_compile() {
	einfo "Compiling icu4j.jar"
	JAVA_SRC_DIR=(
		classes/collate/src
		classes/core/src
		classes/currdata/src
		classes/langdata/src
		classes/regiondata/src
		classes/translit/src
	)
	JAVA_RESOURCE_DIRS=(
		resources/collate/src
		resources/core/src
		resources/currdata/src
		resources/langdata/src
		resources/regiondata/src
		resources/translit/src
		shared/licenses
	)
	JAVA_AUTOMATIC_MODULE_NAME="com.ibm.icu"
	JAVA_JAR_FILENAME="icu4j.jar"
	JAVA_MAIN_CLASS="com.ibm.icu.util.VersionInfo"
	java-pkg-simple_src_compile
	rm -r target || die

	einfo "Compiling icu4j-charset.jar"
	JAVA_AUTOMATIC_MODULE_NAME="com.ibm.icu.charset"
	JAVA_JAR_FILENAME="icu4j-charset.jar"
	JAVA_MAIN_CLASS=""
	JAVA_RESOURCE_DIRS=( resources/charset/src shared/licenses )
	JAVA_SRC_DIR=( classes/charset/src )
	java-pkg-simple_src_compile
	rm -r target || die

	einfo "Compiling icu4j-localespi.jar"
	JAVA_AUTOMATIC_MODULE_NAME="com.ibm.icu.localespi"
	JAVA_JAR_FILENAME="icu4j-localespi.jar"
	JAVA_RESOURCE_DIRS=( resources/localespi/src shared/licenses )
	JAVA_SRC_DIR=( classes/localespi/src )
	java-pkg-simple_src_compile
	rm -r target || die

	# main/test/framework
	# needed for compilicg the tests
	# but "No runnable methods" ("Invalid test class")
	if use test; then
		JAVA_JAR_FILENAME="framework.jar"
		JAVA_RESOURCE_DIRS=( tests/framework/resources ../tools/misc/resources )
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
	# https://bugs.gentoo.org/827212
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
