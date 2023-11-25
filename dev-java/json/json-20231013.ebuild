# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.json:json:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A reference implementation of a JSON package in Java"
HOMEPAGE="https://github.com/stleary/JSON-java"
SRC_URI="https://codeload.github.com/stleary/JSON-java/tar.gz/${PV} -> ${P}.tar.gz
	test? (
		https://repo1.maven.org/maven2/com/jayway/jsonpath/json-path/2.1.0/json-path-2.1.0.jar
		https://repo1.maven.org/maven2/net/minidev/json-smart/2.5.0/json-smart-2.5.0.jar
		https://repo1.maven.org/maven2/net/minidev/asm/1.0.2/asm-1.0.2.jar
	)"
S="${WORKDIR}/JSON-java-${PV}"

LICENSE="JSON"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=virtual/jdk-1.8:*
	test? (
		dev-java/slf4j-api:0
		dev-java/mockito:0
	)
"

RDEPEND=">=virtual/jre-1.8:*"

DOCS=( {CONTRIBUTING,README,SECURITY}.md )
PATCHES=( "${FILESDIR}/json-20231013-JSONObjectTest.patch" )

JAVA_AUTOMATIC_MODULE_NAME="org.json"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="
	asm-9
	junit-4
	mockito
	slf4j-api
"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
}

src_test() {
	JAVA_GENTOO_CLASSPATH_EXTRA="${DISTDIR}/json-path-2.1.0.jar" # Test compile dependency
	JAVA_GENTOO_CLASSPATH_EXTRA+=":${DISTDIR}/json-smart-2.5.0.jar" # Test runtime dependency

	# Exception java.lang.NoClassDefFoundError: net/minidev/asm/FieldFilter
	JAVA_GENTOO_CLASSPATH_EXTRA+=":${DISTDIR}/asm-1.0.2.jar" # Test runtime dependency

	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge 17; then
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.lang=ALL-UNNAMED )
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.io=ALL-UNNAMED )
	fi
	java-pkg-simple_src_test
}
