# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"
MAVEN_ID="com.google.inject:guice:7.0.0"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Guice is a lightweight dependency injection framework for Java 6 and above"
HOMEPAGE="https://github.com/google/guice"
# Currently we bundle these binary versions used only for tests, we don't install it.
TV="1.1.3" # with 1.4.4 there is an 'ambiguous' problem in EnhancedTest.
SRC_URI="https://github.com/google/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	test? (
		https://repo1.maven.org/maven2/com/google/truth/truth/${TV}/truth-${TV}.jar
		https://repo1.maven.org/maven2/com/google/truth/extensions/truth-java8-extension/${TV}/truth-java8-extension-${TV}.jar
	)"
S="${WORKDIR}/${P}/core"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="
	dev-java/aopalliance:1
	dev-java/injection-api:0
	>=dev-java/asm-9.8-r1:0
	>=dev-java/error-prone-annotations-2.41.0:0
	>=dev-java/guava-33.4.8:0
	dev-java/jsr305:0
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
	test? (
		>=dev-java/guava-testlib-33.4.8:0
		dev-java/jakarta-inject-tck:0
		dev-java/osgi-core:0
	)
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( ../{COPYING,{CONTRIBUTING,README}.md} )

PATCHES=(
	# this test passes with jdk 21 and lower
	"${FILESDIR}/guice-7.0.0-skipFailingTest.patch"
)

JAVA_AUTOMATIC_MODULE_NAME="com.google.guice"
JAVA_SRC_DIR="src"
JAVA_TEST_GENTOO_CLASSPATH="guava-testlib jakarta-inject-tck junit-4 osgi-core"
JAVA_TEST_RESOURCE_DIRS="test"
JAVA_TEST_SRC_DIR="test"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare

	# line 99, pom.xml
	rm test/com/googlecode/guice/OSGiContainerTest.java || die "remove OSGITest"
}

src_test() {
	JAVAC_ARGS="-parameters"

	# it needs java8-extension and the older versions
	JAVA_GENTOO_CLASSPATH_EXTRA=":${DISTDIR}/truth-${TV}.jar"
	JAVA_GENTOO_CLASSPATH_EXTRA+=":${DISTDIR}/truth-java8-extension-${TV}.jar"

	# exclude tests not run by mvn test
	JAVA_TEST_EXCLUDES=(
		com.google.inject.AllTests
		com.google.inject.ScopesTest
		com.google.inject.TypeConversionTest
	)

	# line 111, pom.xml
	JAVA_TEST_EXTRA_ARGS=(
		-Dguice_custom_class_loading=ANONYMOUS
		-XX:+UnlockDiagnosticVMOptions
		-XX:+ShowHiddenFrames
	)

	java-pkg-simple_src_test
}
