# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"
MAVEN_ID="org.json:json:${PV}"

inherit java-pkg-2 java-pkg-simple check-reqs

DESCRIPTION="A reference implementation of a JSON package in Java"
HOMEPAGE="https://github.com/stleary/JSON-java"
SRC_URI="https://github.com/stleary/JSON-java/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/JSON-java-${PV}"

LICENSE="JSON"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=virtual/jdk-1.8:*
	test? (
		>=dev-java/asm-9.9.1:0
		>=dev-java/json-path-2.10.0:0
		>=dev-java/json-smart-2.6.0:0
		dev-java/mockito:4
		dev-java/slf4j-api:0
	)
"

RDEPEND=">=virtual/jre-1.8:*"

DOCS=( {CONTRIBUTING,README,SECURITY}.md )

JAVA_AUTOMATIC_MODULE_NAME="org.json"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="
	asm
	json-path
	json-smart
	junit-4
	mockito-4
	slf4j-api
"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

check_env() {
	if use test; then
		# this is needed only for tests
		CHECKREQS_MEMORY="2048M"
		check-reqs_pkg_pretend
	fi
}

pkg_pretend() {
	check_env
}

pkg_setup() {
	check_env
	java-pkg-2_pkg_setup
}

src_test() {
	# setting Xms for bug #930723
	# gradlew: DEFAULT_JVM_OPTS='"-Xmx64m" "-Xms64m"
	JAVA_TEST_EXTRA_ARGS=" -Xmx${CHECKREQS_MEMORY}"

	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge 17; then
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.lang=ALL-UNNAMED )
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.io=ALL-UNNAMED )
	fi
	java-pkg-simple_src_test
}
