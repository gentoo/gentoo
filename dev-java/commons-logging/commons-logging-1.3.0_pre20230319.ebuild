# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="commons-logging:commons-logging:1.3.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Thin adapter allowing configurable bridging to other well known logging systems"
HOMEPAGE="https://commons.apache.org/proper/commons-logging/"
MY_COMMIT="d376d3128663e53de4af948e161291e7ec0c6ec1"
SRC_URI="https://github.com/apache/${PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="log4j"

CDEPEND="
	log4j? (
		dev-java/log4j-12-api:2
		dev-java/log4j-api:2
		dev-java/log4j-core:2
	)
"

DEPEND="${CDEPEND}
	dev-java/javax-servlet-api:2.5
	>=virtual/jdk-1.8:*
"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.8:*"

DOCS=( README.md src/changes/changes.xml )

JAVA_AUTOMATIC_MODULE_NAME="org.apache.commons.logging"
JAVA_ENCODING="iso-8859-1"
JAVA_CLASSPATH_EXTRA="javax-servlet-api-2.5"
JAVA_SRC_DIR="src/main/java"

src_prepare() {
	java-pkg-2_src_prepare
	# https://avalon.apache.org/closed.html Apache Avalon has closed.
	rm src/main/java/org/apache/commons/logging/impl/{Avalon,LogKit}Logger.java || die
	rm src/test/java/org/apache/commons/logging/{avalon/AvalonLogger,logkit/Standard}TestCase.java || die

	if use !log4j; then
		rm src/main/java/org/apache/commons/logging/impl/Log4JLogger.java || die
	fi
}

src_compile() {
	if use log4j; then
		JAVA_GENTOO_CLASSPATH="log4j-12-api-2,log4j-api-2,log4j-core-2"
	fi
	java-pkg-simple_src_compile

	pushd target/classes > /dev/null || die

	# Need Automatic-Module-Name also for the other JAR files
	jar xvf ../../commons-logging.jar META-INF/MANIFEST.MF || die

	# https://github.com/apache/commons-logging/blob/058cf5ee350cd83d1ab28b000ad6be903ca160c5/pom.xml#L215-L236
	jar -cvfm ../../commons-logging-api.jar META-INF/MANIFEST.MF \
		$(find . -type f -name '*.class' \
		! -name 'Jdk13LumberjackLogger.class' \
		! -name 'ServletContextCleaner.class' \
		) || die

	# https://github.com/apache/commons-logging/blob/058cf5ee350cd83d1ab28b000ad6be903ca160c5/pom.xml#L240-L257
	jar -cvfm ../../commons-logging-adapters.jar META-INF/MANIFEST.MF \
		$(find . -type f -path './org/apache/commons/logging/impl/**.class' \
		! -name 'WeakHashtable*.class' \
		! -name 'LogFactoryImpl*.class' \
		) || die

	popd > /dev/null || die
}

src_test() {
	# Do not run Log4j tests because these tests use an Appender to verify
	# logging correctness.  The log4j-12-api bridge no longer supports using an
	# Appender for verifications since the methods for adding an Appender in
	# the bridge "are largely no-ops".  This means an Appender's state would
	# never be changed by log4j-12-api after new messages are logged.  The test
	# cases, however, expect changes to the Appender's state in such an event,
	# so they would fail with log4j-12-api.
	# https://logging.apache.org/log4j/log4j-2.8/log4j-1.2-api/index.html
	rm src/test/java/org/apache/commons/logging/pathable/ParentFirstTestCase.java || die # Log4JLogger
	rm src/test/java/org/apache/commons/logging/pathable/ChildFirstTestCase.java || die # Log4JLogger
	rm -r src/test/java/org/apache/commons/logging/log4j || die

	JAVA_TEST_EXCLUDES=(
		org.apache.commons.logging.security.SecurityForbiddenTestCase # 2 tests 1 failing
		org.apache.commons.logging.jdk14.TestHandler # No runnable methods
	)
	JAVA_TEST_EXTRA_ARGS=(
		-Dservlet-api="$(java-pkg_getjars javax-servlet-api-2.5)"
		-Dcommons-logging="commons-logging.jar"
		-Dcommons-logging-api="commons-logging-api.jar"
		-Dcommons-logging-adapters="commons-logging-adapters.jar"
		-Dtestclasses="target/test-classes"
	)
	if use log4j; then
		JAVA_TEST_EXTRA_ARGS+=" -Dlog4j12=$(java-pkg_getjars log4j-12-api-2,log4j-core-2)"
	fi
	JAVA_TEST_GENTOO_CLASSPATH="junit-4"
	JAVA_TEST_RESOURCE_DIRS="src/test/resources"
	JAVA_TEST_SRC_DIR="src/test/java"
	java-pkg-simple_src_test
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dojar commons-logging-api.jar commons-logging-adapters.jar
}
