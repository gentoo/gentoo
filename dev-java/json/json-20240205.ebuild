# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.json:json:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A reference implementation of a JSON package in Java"
HOMEPAGE="https://github.com/stleary/JSON-java"
JPV="2.4.0"
SRC_URI="https://codeload.github.com/stleary/JSON-java/tar.gz/${PV} -> ${P}.tar.gz
	test? (
		https://repo1.maven.org/maven2/com/jayway/jsonpath/json-path/${JPV}/json-path-${JPV}.jar
	)"
S="${WORKDIR}/JSON-java-${PV}"

LICENSE="JSON"
SLOT="0"
KEYWORDS="amd64 ~x86"

DEPEND="
	>=virtual/jdk-1.8:*
	test? (
		dev-java/asm:9
		dev-java/json-smart:2
		dev-java/mockito:4
		dev-java/slf4j-api:0
	)
"

RDEPEND=">=virtual/jre-1.8:*"

DOCS=( {CONTRIBUTING,README,SECURITY}.md )

JAVA_AUTOMATIC_MODULE_NAME="org.json"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="
	asm-9
	json-smart-2
	junit-4
	mockito-4
	slf4j-api
"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_test() {
	JAVA_GENTOO_CLASSPATH_EXTRA="${DISTDIR}/json-path-${JPV}.jar" # Test compile dependency

	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge 17; then
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.lang=ALL-UNNAMED )
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.io=ALL-UNNAMED )
	fi
	java-pkg-simple_src_test
}
