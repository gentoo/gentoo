# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/qos-ch/reload4j/archive/v_1.2.22.tar.gz --slot 0 --keywords "~amd64" --ebuild reload4j-1.2.22..ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="ch.qos.reload4j:reload4j:1.2.22"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Reload4j revives EOLed log4j 1.x"
HOMEPAGE="https://reload4j.qos.ch"
SRC_URI="https://github.com/qos-ch/reload4j/archive/v_${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# There are unresolved test failures
RESTRICT="test"

# Common dependencies
# POM: pom.xml
# javax.mail:mail:1.4.7 -> !!!groupId-not-found!!!
# org.apache.geronimo.specs:geronimo-jms_1.1_spec:1.0 -> !!!groupId-not-found!!!

CP_DEPEND="
	dev-java/javax-mail:0
	dev-java/jboss-jms-api:1.1
"

# Compile dependencies
# POM: pom.xml
# test? com.h2database:h2:2.1.210 -> !!!groupId-not-found!!!
# test? junit:junit:4.13.1 -> >=dev-java/junit-4.13.2:4

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}"

DOCS=( NOTICE {README,SECURITY}.md )

S="${WORKDIR}/reload4j-v_${PV}"

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

JAVA_TEST_EXCLUDES=(
	#java.sql.SQLException: No suitable driver found for jdbc:h2:mem:test_db
	# com.h2database:h2 is not packaged
	org.apache.log4j.jdbc.JdbcAppenderTest
	# No runnable methods
	org.apache.log4j.TestConstants

	# following tests prefer to fail if not run separately:
	org.apache.log4j.MinimumTestCase
	org.apache.log4j.net.SMTPAppenderTest
	org.apache.log4j.net.SocketAppenderTest
	org.apache.log4j.net.SocketServerTestCase
	org.apache.log4j.net.SyslogAppenderTest
	org.apache.log4j.net.TelnetAppenderTest
	org.apache.log4j.varia.ERFATestCase
	org.apache.log4j.varia.ErrorHandlerTestCase
	org.apache.log4j.xml.CustomLevelTestCase
	org.apache.log4j.xml.DOMTestCase
)

src_test() {
	einfo "Running tests"
	java-pkg-simple_src_test

	JAVA_TEST_RUN_ONLY="org.apache.log4j.MinimumTestCase"
	java-pkg-simple_src_test

	JAVA_TEST_RUN_ONLY="org.apache.log4j.net.SMTPAppenderTest"
	java-pkg-simple_src_test

	JAVA_TEST_RUN_ONLY="org.apache.log4j.net.SocketAppenderTest"
	java-pkg-simple_src_test

	JAVA_TEST_RUN_ONLY="org.apache.log4j.net.SocketServerTestCase"
	java-pkg-simple_src_test

	JAVA_TEST_RUN_ONLY="org.apache.log4j.net.SyslogAppenderTest"
	java-pkg-simple_src_test

	JAVA_TEST_RUN_ONLY="org.apache.log4j.net.TelnetAppenderTest"
	java-pkg-simple_src_test

	JAVA_TEST_RUN_ONLY="org.apache.log4j.varia.ERFATestCase"
	java-pkg-simple_src_test

	JAVA_TEST_RUN_ONLY="org.apache.log4j.varia.ErrorHandlerTestCase"
	java-pkg-simple_src_test

	JAVA_TEST_RUN_ONLY="org.apache.log4j.xml.CustomLevelTestCase"
	java-pkg-simple_src_test

	JAVA_TEST_RUN_ONLY="org.apache.log4j.xml.DOMTestCase"
	java-pkg-simple_src_test
}
