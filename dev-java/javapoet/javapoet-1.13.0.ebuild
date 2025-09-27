# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Use beautiful Java code to generate beautiful Java code."
HOMEPAGE="https://github.com/square/javapoet/"
SRC_URI="https://github.com/square/${PN}/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=virtual/jdk-1.8:*
	test? (
		dev-java/eclipse-ecj:4.20
		dev-java/compile-testing:0
		dev-java/jimfs:0
		dev-java/junit:4
		dev-java/mockito:2
		dev-java/truth:0
	)
"

RDEPEND=">=virtual/jre-1.8:*"

PATCHES=(
	"${FILESDIR}/javapoet-1.13.0-skipFailingTests.patch"
	"${FILESDIR}/javapoet-1.13.0-ClassNameTest.patch"	# works with Java <= 21
)

JAVA_AUTOMATIC_MODULE_NAME="com.squareup.javapoet"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_EXCLUDES=(
	com.squareup.javapoet.TestUtil	# no runnable methods
	com.squareup.javapoet.TestFiler	# no runnable methods
)

JAVA_TEST_GENTOO_CLASSPATH="
	compile-testing
	eclipse-ecj-4.20
	jimfs
	junit-4
	mockito-2
"

JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
}

src_test() {
	# Having 'truth' in JAVA_TEST_GENTOO_CLASSPATH would cause one test failure
	# on 'compileJavaFile(com.squareup.javapoet.FileReadingTest)'.
	# The eclass builds that classpath '--with-dependencies' which would add the
	# annotation processor so that annotation processing gets enabled.
	JAVA_GENTOO_CLASSPATH_EXTRA+=":$(java-pkg_getjars --build-only truth)"

	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge 17; then
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.lang.reflect=ALL-UNNAMED )
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=jdk.compiler/com.sun.tools.javac.code=ALL-UNNAMED )
	fi
	java-pkg-simple_src_test
}
