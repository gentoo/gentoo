# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Trouble with 'doc', seems to need '--add-exports'?
JAVA_PKG_IUSE="source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Testing tools for javac and annotation processors"
HOMEPAGE="https://github.com/google/compile-testing"
SRC_URI="https://github.com/google/compile-testing/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

DEPEND="
	dev-java/auto-value:0
	dev-java/checker-framework-qual:0
	dev-java/error-prone-annotations:0
	dev-java/escapevelocity:0
	>=dev-java/guava-33.4.8:0
	dev-java/incap:0
	dev-java/javapoet:0
	dev-java/junit:4
	dev-java/truth:0
	>=virtual/jdk-11:*
	test? (
		>=dev-java/guava-testlib-33.4.8:0
		dev-java/jspecify:0
	)
"

RDEPEND=">=virtual/jre-1.8:*"

JAVA_CLASSPATH_EXTRA="auto-value checker-framework-qual error-prone-annotations guava junit-4 truth"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="guava-testlib jspecify junit-4"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_compile() {
	# get processorpath
	local pp="$(java-pkg_getjar --build-only auto-value auto-value.jar)"	# processor
	pp="${pp}:$(java-pkg_getjar --build-only auto-value auto-common.jar)"	# dependencies
	pp="${pp}:$(java-pkg_getjars --build-only escapevelocity,guava,incap,javapoet)"

	JAVAC_ARGS=" -processorpath ${pp} -s src/main/java"

	java-pkg-simple_src_compile
}

src_test() {
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge 17; then
		JAVA_TEST_EXTRA_ARGS=( --add-exports=jdk.compiler/com.sun.tools.javac.{api,file,parser,tree,util}=ALL-UNNAMED)
	fi
	java-pkg-simple_src_test
}
