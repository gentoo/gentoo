# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="testng"

inherit java-pkg-2 java-pkg-simple

# Presently we install the binary version of jquery since it is not packaged in ::gentoo.
JQV="3.7.1" # jquery
# These are used only for tests, we don't install them.
AGV="5.0.2" # groovyc compiler
GAV="3.0.22" # groovy
JCV="3.0.1" # jlibs-core, to be packaged
KCV="2.2.0" # kotlin-compiler

DESCRIPTION="Testing framework inspired by JUnit and NUnit with new features"
HOMEPAGE="https://testng.org/"
SRC_URI="https://github.com/testng-team/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://repo1.maven.org/maven2/org/webjars/jquery/${JQV}/jquery-${JQV}.jar
	test? (
		mirror://apache/groovy/${AGV}/distribution/apache-groovy-binary-${AGV}.zip
		https://github.com/JetBrains/kotlin/releases/download/v${KCV}/kotlin-compiler-${KCV}.zip
		https://repo1.maven.org/maven2/in/jlibs/jlibs-core/${JCV}/jlibs-core-${JCV}.jar
		https://repo1.maven.org/maven2/org/codehaus/groovy/groovy/${GAV}/groovy-${GAV}.jar
	)"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

BDEPEND="app-arch/unzip"

CP_DEPEND="
	>=dev-java/guice-7.0.0:0
	>=dev-java/jcommander-1.83:0
	dev-java/slf4j-api:0
	>=dev-java/snakeyaml-2.5:0
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-11:*
	test? (
		>=dev-java/assertj-core-3.27.6:0
		>=dev-java/bsh-2.1.1-r2:0
		>=dev-java/commons-io-2.20.0:0
		>=dev-java/guava-33.5.0:0
		>=dev-java/javax-inject-1-r4:0
		>=dev-java/jetbrains-annotations-26.0.2:0
		dev-java/junit:4
		>=dev-java/mockito-5.20.0:0
		>=dev-java/shrinkwrap-api-1.2.6:0
		>=dev-java/shrinkwrap-impl-base-1.2.6:0
		>=dev-java/slf4j-simple-2.0.3:0
		>=dev-java/xmlunit-core-2.11.0:0
	)
"

# reason: '<>' with anonymous inner classes is not supported in -source 8
#   (use -source 9 or higher to enable '<>' with anonymous inner classes)
RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-11:*
	dev-java/jsr305:0
"

DOCS=( README.md {ANNOUNCEMENT,CHANGES}.txt )
PATCHES=(
	"${FILESDIR}/testng-7.11.0-skipDynamicDataProviderLoadingTest.patch"
	"${FILESDIR}/testng-7.11.0-SkipFrom-ClassHelperTest.patch"
	"${FILESDIR}/testng-7.11.0-SkipFrom-FailedInvocationCountTest.patch"	# needs network
	"${FILESDIR}/testng-7.11.0-SkipFrom-FailedReporterTest.patch"
	"${FILESDIR}/testng-7.11.0-SkipFrom-GroovyTest.patch"
	"${FILESDIR}/testng-7.11.0-SkipFrom-GuiceTest.patch"
	"${FILESDIR}/testng-7.11.0-SkipFrom-HookableTest.patch"
	"${FILESDIR}/testng-7.11.0-SkipFrom-JitBindingTest.patch"
	"${FILESDIR}/testng-7.11.0-SkipFrom-ScriptTest.patch"
	"${FILESDIR}/testng-7.11.0-SkipFrom-XmlSuiteTest.patch"
	"${FILESDIR}/testng-7.11.0-SkipFrom-YamlTest.patch"
)

JAVA_AUTOMATIC_MODULE_NAME="org.testng"
JAVA_MAIN_CLASS="org.testng.TestNG"
JAVA_RESOURCE_DIRS="testng-core/src/main/resources"
JAVA_SRC_DIR=(
	testng-asserts/src/main/java
	testng-collections/src/main/java
	testng-core-api/src/main/java
	testng-core/src/main/java
	testng-reflection-utils/src/main/java
	testng-runner-api/src/main/java
)

JAVA_TEST_EXTRA_ARGS=( -Dtest.resources.dir=src/test/resources )
JAVA_TEST_GENTOO_CLASSPATH="assertj-core bsh commons-io guice javax-inject jetbrains-annotations junit-4 mockito shrinkwrap-api shrinkwrap-impl-base slf4j-simple xmlunit-core"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_RUN_ONLY="testng-core/src/test/resources/testng.xml"
JAVA_TEST_SRC_DIR=(
	testng-core/src/test
	testng-asserts/src/test
	testng-test-kit/src/main/java
#	testng-test-osgi/src/test/java # error: package org.ops4j.pax.exam does not exist
)

src_unpack () {
	# do not unpack anything except testng
	unpack "${P}.tar.gz"
}

src_prepare() {
	default # bug #780585
	java-pkg-2_src_prepare
	java-pkg_clean ! -path "./testng-core/src/test/*"
	mkdir -p src/test || die
	cp -vr testng-core/src/test/resources src/test || die "move test resources"
	mkdir -p build/resources/test || die
	cp {testng-core/src/test/resources,build/resources/test}/2532.xml || die
}

src_test() {
	# import org.netbeans.lib.profiler.heap.HeapFactory2 # error: unresolved reference 'HeapFactory2'
	# Tried with 'org-netbeans-lib-profiler-2.2.0.jar' which contains 'HeapFactory' but not 'HeapFactory2'.
	rm testng-core/src/test/kotlin/org/testng/dataprovider/DynamicDataProviderLoadingTest.kt || die
	# With a patch we also remove it from testng-core/src/test/resources/testng.xml

	# Removing the above file leads to:
	# import org.testng.dataprovider.DynamicDataProviderLoadingTest
	# error: unresolved reference 'DynamicDataProviderLoadingTest'.
	rm testng-core/src/test/kotlin/org/testng/dataprovider/sample/issue2724/SampleDPUnloaded.kt || die

	# Almost all tests want to 'import test.SimpleBaseTest;'. In the past this was
	# built from 'SimpleBaseTest.java' which was changed to 'SimpleBaseTest.kt'.

	# Step 1 creates a list of sources to be processed with 'kotlinc'
	# (the kotlin compiler), then lets it create the classes.
	unzip -q "${DISTDIR}/kotlin-compiler-${KCV}.zip" || die "unzip kotlin"
	local CP="${DISTDIR}/jlibs-core-${JCV}.jar"
	find ${JAVA_TEST_SRC_DIR[@]} \
		-type f \( -name '*.kt' -o -name '*.java' \) \
		> testng_kotlinc_sources || die "find for kotlinc"
	einfo "Running kotlinc"
	kotlinc/bin/kotlinc \
		-cp "${PN}.jar:${CP}:$(java-pkg_getjars --build-only assertj-core)" \
		-d generated-test @testng_kotlinc_sources || die "kotlinc"

	# Step 2 creates a few classes which are needed for processing '*.groovy' sources.
	find ${JAVA_TEST_SRC_DIR[@]} -type f -name 'InvokedMethodNameListener.java' \
		> testng_ejavac_sources || die "find"
	einfo "Running ejavac"
	ejavac \
		-cp "${PN}.jar:generated-test:$(java-pkg_getjars --build-only guava)" \
		-d generated-test @testng_ejavac_sources

	# Step 3 creates a list of '*.groovy' sources and passes it to
	# groovyc (the groovy compiler) for creating the classes.
	unzip -q "${DISTDIR}/apache-groovy-binary-${AGV}.zip" || die
	find ${JAVA_TEST_SRC_DIR[@]} -type f -name '*.groovy' \
		> testng_groovy_sources || die "find"
	einfo "Running groovyc"
	"groovy-${AGV}/bin/groovyc" \
		-cp generated-test:"$(java-pkg_getjars --build-only assertj-core)" \
		-d generated-test @testng_groovy_sources || die

	# Step 4 finally builds all remaining test-classes and runs the tests.
	JAVA_GENTOO_CLASSPATH_EXTRA="${DISTDIR}/groovy-${GAV}.jar"
	JAVA_GENTOO_CLASSPATH_EXTRA+=":kotlinc/lib/kotlin-stdlib.jar"
	JAVA_GENTOO_CLASSPATH_EXTRA+=":kotlinc/lib/kotlin-reflect.jar"
	JAVA_TEST_EXTRA_ARGS=( -Dtest.resources.dir=src/test/resources )
	java-pkg-simple_src_test
}

src_install() {
	java-pkg-simple_src_install

	java-pkg_newjar "${DISTDIR}/jquery-${JQV}.jar" jquery.jar
	java-pkg_regjar "${ED}/usr/share/${PN}/lib/jquery.jar"

	java-pkg_register-dependency jsr305
}
