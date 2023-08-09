# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.google.code.gson:gson:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Gson JSON library"
HOMEPAGE="https://github.com/google/gson"
SRC_URI="https://github.com/google/gson/archive/gson-parent-${PV}.tar.gz"
S="${WORKDIR}/gson-gson-parent-${PV}/gson"

LICENSE="Apache-2.0"
SLOT="2.6"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND=">=virtual/jdk-17:*"
RDEPEND=">=virtual/jre-1.8:*"

DOCS=(
	../CHANGELOG.md
	../GsonDesignDocument.md
	../README.md
	../Troubleshooting.md
	../UserGuide.md
)

JAVA_SRC_DIR=(
	"src/main/java"
	"src/main/java-templates"
)

JAVA_TEST_EXCLUDES=(
	# requires the test class to be obfuscated using proguard which we do not have atm
	"com.google.gson.functional.EnumWithObfuscatedTest"
	# FAILURES!!!
	# Tests run: 1258,  Failures: 2
	# testComGoogleGsonAnnotationsPackage(com.google.gson.regression.OSGiTest)
	# junit.framework.AssertionFailedError: Cannot find com.google.gson OSGi bundle manifest
	"com.google.gson.regression.OSGiTest"
)
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	java-pkg-2_src_prepare
	sed -e "s/\${project.version}/${PV}/g" \
		-i src/main/java-templates/com/google/gson/internal/GsonBuildConfig.java \
			|| die "Failed to set version"
	# error: records are not supported in -source 8
	# This test would pass "OK (25 tests)" only with >=jre-17
	# pom.xml, lines 20-22
	rm src/test/java/com/google/gson/functional/Java17RecordTest.java || die
}
