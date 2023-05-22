# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.jtwig:jtwig-reflection:${PV}.RELEASE"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jtwig Reflection Library"
HOMEPAGE="https://github.com/jtwig/jtwig-reflection"
SRC_URI="https://github.com/jtwig/jtwig-reflection/archive/${PV}.RELEASE.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}.RELEASE"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-java/commons-lang:3.6
	dev-java/guava:0
	dev-java/slf4j-api:0
	>=virtual/jdk-1.8:*
	test? (
		dev-java/commons-io:1
		dev-java/hamcrest:0
		dev-java/mockito:0
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
"

JAVA_CLASSPATH_EXTRA="
	commons-lang-3.6
	guava
	slf4j-api
"

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_EXCLUDES=(
	# Invalid test class; No runnable methods
	org.jtwig.reflection.integration.example.TestArgumentValueResolver
	org.jtwig.reflection.integration.example.TestArgumentResolver
	org.jtwig.reflection.integration.example.TestArgument
)
JAVA_TEST_GENTOO_CLASSPATH="
	commons-io-1
	hamcrest
	junit-4
	mockito
"
JAVA_TEST_SRC_DIR="src/test/java"

src_test() {
	# Unable to make field private final byte[] java.lang.String.value accessible:
	# module java.base does not "opens java.lang" to unnamed module @3bc9f433
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge 17; then
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.lang=ALL-UNNAMED )
	fi
	java-pkg-simple_src_test
}
