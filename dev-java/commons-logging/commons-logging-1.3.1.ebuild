# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="commons-logging:commons-logging:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Thin adapter allowing configurable bridging to other well known logging systems"
HOMEPAGE="https://commons.apache.org/proper/commons-logging/"
SRC_URI="mirror://apache/commons/logging/source/${P}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/commons/logging/source/${P}-src.tar.gz.asc )"
S="${WORKDIR}/${P}-src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="log4j"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/commons.apache.org.asc"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"
COMMON_DEPEND="
	dev-java/jakarta-servlet-api:4
	dev-java/slf4j-api:0
	log4j? (
		dev-java/log4j-12-api:2
		dev-java/log4j-api:2
	)"

DEPEND="${COMMON_DEPEND}
	>=virtual/jdk-11:*"

RDEPEND="${COMMON_DEPEND}
	>=virtual/jre-1.8:*"

DOCS=( NOTICE.txt src/changes/changes.xml )
HTML_DOCS=( PROPOSAL.html )

JAVA_AUTOMATIC_MODULE_NAME="org.apache.commons.logging"
JAVA_ENCODING="iso-8859-1"
JAVA_GENTOO_CLASSPATH="
	jakarta-servlet-api-4
	slf4j-api
"
JAVA_SRC_DIR="src/main/java"

src_prepare() {
	java-pkg-2_src_prepare

	# javax-servlet-api and log4j* do not presently provide module-info
	cat > src/main/java/module-info.java <<-EOF || die
		module org.apache.commons.logging {
		//	requires static org.apache.logging.log4j;
			requires static org.slf4j;
			requires static java.logging;
		//	requires static log4j;
		//	requires static servlet.api;
		//	requires static org.apache.log4j;
			requires java.base;
			exports org.apache.commons.logging;
			exports org.apache.commons.logging.impl;
			uses org.apache.commons.logging.LogFactory;
		}
	EOF

	# https://avalon.apache.org/closed.html Apache Avalon has closed.
	rm src/main/java/org/apache/commons/logging/impl/{Avalon,LogKit}Logger.java || die
	rm src/test/java/org/apache/commons/logging/{avalon/AvalonLogger,logkit/Standard}TestCase.java || die

	if use !log4j; then
		rm src/main/java/org/apache/commons/logging/impl/Log4JLogger.java || die
		rm src/main/java/org/apache/commons/logging/impl/Log4jApiLogFactory.java || die
	else
		JAVA_GENTOO_CLASSPATH+="
			log4j-12-api-2
			log4j-api-2
		"
	fi
}

src_compile() {
	java-pkg-simple_src_compile

	pushd target/classes > /dev/null || die

	# Need Automatic-Module-Name also for the other JAR files
	jar xvf ../../commons-logging.jar META-INF/MANIFEST.MF || die

	# pom.xml, lines 81-103
	jar -cvfm ../../commons-logging-api.jar META-INF/MANIFEST.MF \
		$(find . -type f -name '*.class' \
		! -name 'Jdk13LumberjackLogger.class' \
		! -name 'ServletContextCleaner.class' \
		) || die

	# pom.xml, lines 205-124
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
	rm src/test/java/org/apache/commons/logging/log4j2/CallerInformationTestCase.java || die
	# error: package ch.qos.logback.classic does not exist
	rm src/test/java/org/apache/commons/logging/slf4j/CallerInformationTestCase.java || die

	JAVA_TEST_EXCLUDES=(
		org.apache.commons.logging.jdk14.TestHandler # No runnable methods
		# junit.framework.AssertionFailedError: Wrong factory retrieved through
		# ServiceLoader: org.apache.commons.logging.impl.Slf4jLogFactory
		org.apache.commons.logging.serviceloader.ServiceLoaderTestCase
		# junit.framework.ComparisonFailure: Log class expected:<...ommons.logging.impl.[NoOp]Log>
		# but was:<...ommons.logging.impl.[Slf4jLogFactory$Slf4j]Log>
		org.apache.commons.logging.noop.NoOpLogTestCase
	)
	JAVA_TEST_EXTRA_ARGS=(
		-Dservlet-api="$(java-pkg_getjars jakarta-servlet-api-4)"
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
