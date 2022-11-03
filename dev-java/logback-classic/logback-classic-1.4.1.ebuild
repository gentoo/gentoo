# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom logback-classic/pom.xml --download-uri https://github.com/qos-ch/logback/archive/v_1.4.1.tar.gz --slot 0 --keywords "~amd64" --ebuild logback-classic-1.4.1.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="ch.qos.logback:logback-classic:1.4.1"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="logback-classic module"
HOMEPAGE="https://logback.qos.ch"
SRC_URI="https://github.com/qos-ch/logback/archive/v_${PV}.tar.gz -> logback-${PV}.tar.gz"

LICENSE="EPL-1.0 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

# Common dependencies
# POM: ${PN}/pom.xml
# ch.qos.logback:logback-core:1.4.1 -> >=dev-java/logback-core-1.4.1:0
# jakarta.mail:jakarta.mail-api:2.0.1 -> >=dev-java/jakarta-mail-api-2.1.0:0
# org.codehaus.janino:janino:3.1.7 -> >=dev-java/janino-3.1.7:0
# org.slf4j:slf4j-api:2.0.1 -> >=dev-java/slf4j-api-2.0.3:0

CP_DEPEND="
	~dev-java/janino-3.1.7:0
	dev-java/jakarta-mail-api:0
	~dev-java/logback-core-${PV}:0
	>=dev-java/slf4j-api-2.0.0:0
"

# Compile dependencies
# POM: ${PN}/pom.xml
# jakarta.servlet:jakarta.servlet-api:5.0.0 -> >=dev-java/jakarta-servlet-api-6.0.0:6
# POM: ${PN}/pom.xml
# test? ch.qos.logback:logback-core:1.4.1 -> >=dev-java/logback-core-1.4.1:0
# test? ch.qos.reload4j:reload4j:1.2.18.4 -> >=dev-java/reload4j-1.2.22:0
# test? com.icegreen:greenmail:2.0.0-alpha-1 -> >=dev-java/greenmail-2.0.0_alpha2:2
# test? junit:junit:4.13.1 -> >=dev-java/junit-4.13.2:4
# test? org.apache.felix:org.apache.felix.main:5.6.10 -> >=dev-java/felix-main-7.0.5:0
# test? org.assertj:assertj-core:1.7.1 -> >=dev-java/assertj-core-2.3.0:2
# test? org.dom4j:dom4j:2.0.3 -> >=dev-java/dom4j-2.1.3:1
# test? org.mockito:mockito-core:4.3.0 -> >=dev-java/mockito-4.8.0:4
# test? org.slf4j:jul-to-slf4j:2.0.1 -> >=dev-java/jul-to-slf4j-2.0.3:0
# test? org.slf4j:log4j-over-slf4j:2.0.1 -> >=dev-java/log4j-over-slf4j-2.0.3:0
# test? org.slf4j:slf4j-api:2.0.1 -> >=dev-java/slf4j-api-2.0.3:0

DEPEND="
	>=virtual/jdk-11:*
	${CP_DEPEND}
	dev-java/jakarta-servlet-api:6
	test? (
		dev-java/assertj-core:3
		dev-java/dom4j:1
		dev-java/felix-main:0
		dev-java/greenmail:2
		dev-java/jul-to-slf4j:0
		dev-java/log4j-over-slf4j:0
		dev-java/logback-core:0
		dev-java/mockito:4
		dev-java/osgi-core:0
		dev-java/reload4j:0
	)
"

# Runtime dependencies
# POM: ${PN}/pom.xml
# com.sun.mail:jakarta.mail:2.0.1 -> >=dev-java/jakarta-mail-2.0.1:0

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
	dev-java/jakarta-mail:0
"

S="${WORKDIR}/logback-v_${PV}/logback-classic"

JAVA_CLASSPATH_EXTRA="jakarta-servlet-api-6"
JAVA_GENTOO_CLASSPATH+="jakarta-mail"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="
	assertj-core-3
	felix-main
	greenmail-2
	jul-to-slf4j
	junit-4
	log4j-over-slf4j
	mockito-4
	reload4j
"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

JAVA_TEST_EXCLUDES=(
	# Invalid test classes, "No runnable methods"
	ch.qos.logback.core.testUtil.EnvUtilForTests
	ch.qos.logback.core.rolling.testUtil.ScaffoldingForRollingTests
	ch.qos.logback.classic.util.TestHelper

	# Test failures:
	ch.qos.logback.classic.net.SMTPAppender_GreenTest # 14 tests

	# 1) versionTest(ch.qos.logback.classic.util.EnvUtilTest)
	# java.lang.AssertionError
	# 	at org.junit.Assert.fail(Assert.java:87)
	# 	at org.junit.Assert.assertTrue(Assert.java:42)
	# 	at org.junit.Assert.assertNotNull(Assert.java:713)
	# 	at org.junit.Assert.assertNotNull(Assert.java:723)
	# 	at ch.qos.logback.classic.util.EnvUtilTest.versionTest(EnvUtilTest.java:17)
	ch.qos.logback.classic.util.EnvUtilTest

	# 2) testSmoke(org.slf4j.test_osgi.BundleTest)
	# junit.framework.AssertionFailedError
	# 	at junit.framework.Assert.fail(Assert.java:55)
	# 	at junit.framework.Assert.assertTrue(Assert.java:22)
	# 	at junit.framework.Assert.assertTrue(Assert.java:31)
	# 	at junit.framework.TestCase.assertTrue(TestCase.java:200)
	# 	at org.slf4j.test_osgi.BundleTest.testSmoke(BundleTest.java:41)
	org.slf4j.test_osgi.BundleTest
)

src_test() {
	# Tests need dom4j:1 on classpath but without dependencies:
	JAVA_GENTOO_CLASSPATH_EXTRA="$(java-pkg_getjars --build-only dom4j-1)"

	# package ch.qos.logback.core.contention does not exist
	JAVA_GENTOO_CLASSPATH_EXTRA+=":../logback-core/src/test/java/"
	java-pkg-simple_src_test
}
