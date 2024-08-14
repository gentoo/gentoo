# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.google.code.gson:gson:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Gson JSON library"
HOMEPAGE="https://github.com/google/gson"
SRC_URI="https://github.com/google/gson/archive/gson-parent-${PV}.tar.gz
	test? ( https://repo1.maven.org/maven2/com/google/truth/truth/1.1.3/truth-1.1.3.jar )"
S="${WORKDIR}/gson-gson-parent-${PV}/gson"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"

DEPEND="
	dev-java/error-prone-annotations:0
	>=virtual/jdk-11:*
	test? (
		dev-java/guava:0
		dev-java/guava-testlib:0
	)
"

RDEPEND=">=virtual/jre-1.8:*"

DOCS=(
	../CHANGELOG.md
	../GsonDesignDocument.md
	../README.md
	../Troubleshooting.md
	../UserGuide.md
)

PATCHES=( "${FILESDIR}/gson-2.10.2-GsonVersionDiagnosticsTest.patch" )

JAVA_CLASSPATH_EXTRA="error-prone-annotations"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR=(
	"src/main/java"
	"src/main/java-templates"
)

JAVA_TEST_EXCLUDES=(
	# requires the test class to be obfuscated using proguard which we do not have atm
	"com.google.gson.functional.EnumWithObfuscatedTest"
)
JAVA_TEST_GENTOO_CLASSPATH="
	guava
	guava-testlib
	junit-4
"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
	sed -e "s/\${project.version}/${PV}/g" \
		-i src/main/java-templates/com/google/gson/internal/GsonBuildConfig.java \
			|| die "Failed to set version"
	grep ^Bundle bnd.bnd > src/main/resources/META-INF/MANIFEST.MF || die
	echo "Import-Package: sun.misc;resolution:=optional, com.google.gson.annotations" \
		>> src/main/resources/META-INF/MANIFEST.MF || die
}

src_test() {
	JAVA_GENTOO_CLASSPATH_EXTRA="${DISTDIR}/truth-1.1.3.jar:testdata.jar"

	# src/test/java/com/google/gson/functional/Java17RecordTest.java:78:
	# error: records are not supported in -source 11
	JAVAC_ARGS="--source 17 --target 17" java-pkg-simple_src_test
}
