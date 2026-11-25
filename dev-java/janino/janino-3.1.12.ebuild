# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="An embedded compiler for run-time compilation purposes"
HOMEPAGE="https://janino-compiler.github.io/janino/"
SRC_URI="https://github.com/janino-compiler/janino/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}/janino"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

DEPEND="
	>=virtual/jdk-1.8:*
	>=dev-java/ant-1.10.15-r1:0
	test? (
		dev-java/jdisasm:0
	)
"

RDEPEND=">=virtual/jre-1.8:*"

JAVADOC_SRC_DIRS=( {../commons-compiler/,}src/main/java )

src_prepare() {
	java-pkg-2_src_prepare
	java-pkg_clean
}

src_compile() {
	JAVA_JAR_FILENAME="commons-compiler.jar"
	JAVA_SRC_DIR="../commons-compiler/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":commons-compiler.jar"
	rm -r target || die

	JAVA_CLASSPATH_EXTRA="ant"
	JAVA_JAR_FILENAME="janino.jar"
	JAVA_RESOURCE_DIRS="src/main/resources"
	JAVA_SRC_DIR="src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":janino.jar"
	rm -r target || die

	JAVADOC_CLASSPATH="${JAVA_CLASSPATH_EXTRA}"
	use doc && ejavadoc
}

src_test() {
	einfo "Testing commons-compiler"
	JAVA_TEST_GENTOO_CLASSPATH="junit-4"
	JAVA_TEST_RESOURCE_DIRS="../commons-compiler/src/test/resources"
	JAVA_TEST_SRC_DIR="../commons-compiler/src/test/java"
	java-pkg-simple_src_test

	einfo "Testing janino"
	JAVA_TEST_GENTOO_CLASSPATH="jdisasm,junit-4"
	JAVA_TEST_RESOURCE_DIRS="src/test/resources"
	JAVA_TEST_SRC_DIR="src/test/java"
	java-pkg-simple_src_test
}

src_install() {
	java-pkg_dojar commons-compiler.jar
	java-pkg-simple_src_install

	if use source; then
		java-pkg_dosrc "../commons-compiler/src/main/java/*"
		java-pkg_dosrc "src/main/java/*"
	fi
}
