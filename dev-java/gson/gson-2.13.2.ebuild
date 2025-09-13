# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Gson JSON library"
HOMEPAGE="https://github.com/google/gson"
SRC_URI="https://github.com/google/gson/archive/gson-parent-${PV}.tar.gz"
S="${WORKDIR}/gson-gson-parent-${PV}/gson"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-java/error-prone-annotations-2.41.0:0
	>=virtual/jdk-11:*
	test? (
		>=dev-java/guava-33.4.8:0
		>=dev-java/guava-testlib-33.4.8:0
		dev-java/truth:0
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

JAVA_CLASSPATH_EXTRA="error-prone-annotations"
JAVA_INTERMEDIATE_JAR_NAME="com.google.gson"
JAVA_RELEASE_SRC_DIRS=( ["9"]="src/main/java9" )
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR=( src/main/java{,-templates} )

# requires the test class to be obfuscated using proguard which we do not have atm
JAVA_TEST_EXCLUDES=( "com.google.gson.functional.EnumWithObfuscatedTest" )

JAVA_TEST_GENTOO_CLASSPATH="guava guava-testlib junit-4 truth"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	java-pkg-2_src_prepare

	sed -e "s/\${project.version}/${PV}/g" \
		-i src/main/java-templates/com/google/gson/internal/GsonBuildConfig.java \
			|| die "Failed to set version"

	# Upstream builds it as META-INF/versions/9/module-info.class
	mkdir -p src/main/java9 || die "mkdir java9"
	mv src/main/java{,9}/module-info.java || die "move module-info.java"
}

src_test() {
	# src/test/java/com/google/gson/functional/Java17RecordTest.java:78:
	# error: records are not supported in -source 11
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge 17 ; then
		JAVAC_ARGS="--source 17 --target 17" java-pkg-simple_src_test
	else
		einfo "Tests need at least Java 17"
	fi
}
