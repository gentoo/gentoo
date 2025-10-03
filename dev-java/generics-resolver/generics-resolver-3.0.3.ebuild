# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
# JAVA_TESTING_FRAMEWORKS="junit-4" ??

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java generics runtime resolver"
HOMEPAGE="https://xvik.github.io/generics-resolver/3.0.3/"
# For compiling the tests, we currently bundle binary versions of spock-core and apache-groovy-binary.
SCV="1.0-groovy-2.4"
AGV="2.4.21"
SRC_URI="https://github.com/xvik/generics-resolver/archive/${PV}.tar.gz -> ${P}.tar.gz
	test? (
		https://repo1.maven.org/maven2/org/spockframework/spock-core/${SCV}/spock-core-${SCV}.jar
		https://downloads.apache.org/groovy/${AGV}/distribution/apache-groovy-binary-${AGV}.zip
	)"
S="${WORKDIR}/${P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# TODO: Run the tests
RESTRICT="test"

BDEPEND="app-arch/unzip"
DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/groovy"

src_test() {
	# This contains the compiler groovyc
	unzip "${DISTDIR}/apache-groovy-binary-${AGV}.zip"

	mkdir -p target/test-classes || die "test-classes"

	local sources	# list of all '*.java' files
	find src/test/groovy -type f -name '*.java' > test_sources || die "sources"
	ejavac -d target/test-classes @test_sources

	local grsources	# list of all '*.groovy' files
	find src/test/groovy -type f -name '*.groovy' > grtest_sources || die "grsources"
	"groovy-${AGV}/bin/groovyc" \
		-cp "${DISTDIR}/spock-core-${SCV}.jar:generics-resolver.jar:target/test-classes" \
		-d target/test-classes @grtest_sources || die "groovyc"

#	java-pkg-simple_src_test ??
}
