# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"
MAVEN_PROVIDES="
	net.minidev:accessors-smart:${PV}
	net.minidev:json-smart:${PV}
"

inherit java-pkg-2 java-pkg-simple junit5

DESCRIPTION="JSON Small and Fast Parser"
HOMEPAGE="https://urielch.github.io"
SRC_URI="https://github.com/netplex/json-smart-v2/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-v2-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

DEPEND="
	dev-java/asm:0
	>=virtual/jdk-1.8:*
	test? ( dev-java/opentest4j:0 )
"

RDEPEND=">=virtual/jre-1.8:*"

JAVADOC_CLASSPATH="asm"
JAVADOC_SRC_DIRS=( {accessors,json}-smart/src/main/java )
JAVA_TEST_GENTOO_CLASSPATH="junit-5 opentest4j"

src_compile() {
	einfo "Compiling accessors-smart.jar"
	JAVA_CLASSPATH_EXTRA="asm"
	JAVA_JAR_FILENAME="accessors-smart.jar"
	JAVA_SRC_DIR="accessors-smart/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":accessors-smart.jar"
	rm -r target || die

	einfo "Compiling json-smart.jar"
	JAVA_JAR_FILENAME="json-smart.jar"
	JAVA_SRC_DIR="json-smart/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":json-smart.jar"
	rm -r target || die

	use doc && ejavadoc
}

src_test() {
	JAVA_TEST_SRC_DIR="accessors-smart/src/test/java"
	junit5_src_test

	JAVA_TEST_SRC_DIR="json-smart/src/test/java"
	junit5_src_test
}

src_install() {
	einstalldocs
	java-pkg_dojar "accessors-smart.jar"
	java-pkg_dojar "json-smart.jar"

	if use doc; then
		java-pkg_dojavadoc target/api
	fi

	if use source; then
		java-pkg_dosrc "accessors-smart/src/main/java/*"
		java-pkg_dosrc "json-smart/src/main/java/*"
	fi
}
