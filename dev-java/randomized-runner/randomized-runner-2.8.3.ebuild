# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.carrotsearch.randomizedtesting:randomizedtesting-runner:2.8.2"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JUnit test runner and plugins for running JUnit tests with pseudo-randomness"
HOMEPAGE="https://labs.carrotsearch.com/randomizedtesting.html"
SRC_URI="https://github.com/randomizedtesting/randomizedtesting/archive/release/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/randomizedtesting-release-${PV}/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

CP_DEPEND="dev-java/junit:4"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
	test? ( dev-java/assertj-core:3 )
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( ../{CHANGES,CONTRIBUTING,README}.txt )

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="assertj-core-3,junit-4"
JAVA_TEST_SRC_DIR="src/test/java"

src_test() {
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if [[ "${vm_version}" -ge "17" ]] ; then
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.lang=ALL-UNNAMED )
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.util=ALL-UNNAMED )
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/sun.nio.fs=ALL-UNNAMED )
	fi

	java-pkg-simple_src_test
}
