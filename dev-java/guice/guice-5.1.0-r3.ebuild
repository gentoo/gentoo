# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"
MAVEN_ID="com.google.inject:guice:5.1.0"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Guice is a lightweight dependency injection framework for Java 6 and above"
HOMEPAGE="https://github.com/google/guice"
JITV="1"
SRC_URI="https://github.com/google/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://repo1.maven.org/maven2/javax/inject/javax.inject-tck/${JITV}/javax.inject-tck-${JITV}.jar )"
S="${WORKDIR}/${P}/core"

LICENSE="Apache-2.0"
SLOT="4"
KEYWORDS="~amd64"

CP_DEPEND="
	dev-java/aopalliance:1
	>=dev-java/asm-9.8-r1:0
	>=dev-java/error-prone-annotations-2.41.0:0
	>=dev-java/guava-33.4.8:0
	dev-java/javax-inject:0
	dev-java/jsr305:0
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
	test? (
		>=dev-java/guava-testlib-33.4.8:0
		>=dev-java/osgi-core-8.0.0:0
		dev-java/truth:0
	)
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( ../{COPYING,{CONTRIBUTING,README}.md} )

PATCHES=(
	# passes with jdk 17 but has 2 test failures with jdk 21
	# and 3 test failures with jdk 25 or higher
	"${FILESDIR}/guice-5.1.0-r2-skipFailingBindingAnnotationTest.patch"

	# passes with jdk 17 but has 1 test failure with jdk 21
	# and 2 test failures with jdk 25 or higher
	"${FILESDIR}/guice-5.1.0-r2-skipFailingProvisionExceptionTest.patch"

	# passes with jdk 17 but has 2 test failures with jdk 21
	# and 3 test failures with jdk 25 or higher
	"${FILESDIR}/guice-5.1.0-r2-skipFailingMissingImplementationErrorTest.patch"
)

JAVA_GENTOO_CLASSPATH_EXTRA="${DISTDIR}/javax.inject-tck-${JITV}.jar"
JAVA_RESOURCE_DIRS="res"
JAVA_SRC_DIR="src"
JAVA_TEST_GENTOO_CLASSPATH="guava-testlib junit-4 osgi-core truth"
JAVA_TEST_RESOURCE_DIRS="test"
JAVA_TEST_SRC_DIR="test"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
	mkdir -p "res/com/google/inject/" || die
	cp {src,res}/com/google/inject/BUILD || die

	# test/com/googlecode/guice/OSGiContainerTest.java:138: error:
	# incompatible types: Properties cannot be converted to Map<String,String>
	#       Framework framework = frameworkFactory.newFramework(properties);
	#                                                           ^
	rm test/com/googlecode/guice/OSGiContainerTest.java || die "remove OSGITest"
}

src_test() {
	JAVAC_ARGS="-parameters"

	# exclude tests which would also fail with 'mvn clean test'
	# exclude AllTests which is not run by 'mvn clean test'
	JAVA_TEST_EXCLUDES=(
		com.google.inject.errors.ErrorMessagesTest
		com.google.inject.spi.ModuleAnnotatedMethodScannerTest
		com.google.inject.internal.UniqueAnnotationsTest
		com.google.inject.AllTests
	)

	java-pkg-simple_src_test
}
