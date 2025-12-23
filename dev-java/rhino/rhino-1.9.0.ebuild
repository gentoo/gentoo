# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-vintage"

inherit java-pkg-2 java-pkg-simple junit5

DESCRIPTION="Rhino JavaScript runtime jar, excludes XML, tools, and ScriptEngine wrapper"
HOMEPAGE="https://github.com/mozilla/rhino"
SRC_URI="https://github.com/mozilla/rhino/archive/Rhino${PV//./_}_Release.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/rhino-Rhino${PV//./_}_Release/rhino"

LICENSE="MPL-1.1 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

DEPEND="
	>=virtual/jdk-11
	test? (
		dev-java/junit:4
		dev-java/junit:5[vintage]
	)
"

# rhino/src/main/java/org/mozilla/javascript/Slot.java:29: error: cannot find symbol
#         var newSlot = new Slot(this);
#         ^
#   symbol:   class var
RDEPEND=">=virtual/jre-11:*"

DOCS=( ../{CODE_OF_CONDUCT,README,RELEASE-NOTES,RELEASE-STEPS}.md ../{NOTICE-tools,NOTICE}.txt )
PATCHES=( "${FILESDIR}/rhino-1.9.0-ClassCompilerTest.patch" )

JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_EXTRA_ARGS=( -Dtest.file.rhino-test-config.loaded=true -Dtest.config.bar=value4-mod )
JAVA_TEST_GENTOO_CLASSPATH="junit-4 junit-5"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	default # bug #780585
	java-pkg-2_src_prepare
}

src_test() {
	JAVA_GENTOO_CLASSPATH_EXTRA="rhino.jar"
	JAVA_JAR_FILENAME="testutils.jar"
	JAVA_SRC_DIR="../testutils/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":testutils.jar"

	# One test needs to run first, otherwise it would fail.
	JAVA_TEST_RUN_ONLY=( org.mozilla.javascript.tests.ErrorHandlingTest )
	local JAVA_TEST_RUN_LATER=$(find src/test/java -name '*Test.java' -printf '%P\n')
	JAVA_TEST_RUN_LATER="${JAVA_TEST_RUN_LATER//.java}"
	JAVA_TEST_RUN_ONLY+=( ${JAVA_TEST_RUN_LATER//\//.} )
	junit5_src_test

	JAVA_JAR_FILENAME="rhino.jar"
}
