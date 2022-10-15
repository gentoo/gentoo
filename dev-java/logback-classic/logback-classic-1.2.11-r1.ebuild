# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/qos-ch/logback/archive/v_1.2.11.tar.gz --slot 0 --keywords "~amd64" --ebuild logback-classic-1.2.11.ebuild

EAPI=8

# No tests, too many dependencies missing
JAVA_PKG_IUSE="doc source"
MAVEN_ID="ch.qos.logback:logback-classic:1.2.11"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="logback-classic module"
HOMEPAGE="https://logback.qos.ch"
SRC_URI="https://github.com/qos-ch/logback/archive/v_${PV}.tar.gz -> logback-${PV}.tar.gz"

LICENSE="EPL-1.0 LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

# Common dependencies
# POM: pom.xml
# ch.qos.logback:logback-core:1.2.11 -> >=dev-java/logback-core-1.2.11:0
# javax.mail:mail:1.4 -> !!!groupId-not-found!!!
# javax.servlet:javax.servlet-api:3.1.0 -> !!!groupId-not-found!!!
# org.codehaus.janino:janino:3.0.6 -> >=dev-java/janino-3.1.6:0
# org.slf4j:slf4j-api:1.7.32 -> >=dev-java/slf4j-api-1.7.32:0

CP_DEPEND="
	dev-java/janino:0
	dev-java/javax-mail:0
	~dev-java/logback-core-${PV}:0
	dev-java/reflections:0
	dev-java/slf4j-api:1
	java-virtuals/servlet-api:3.1
"

# Compile dependencies
# POM: pom.xml
# test? ch.qos.cal10n.plugins:maven-cal10n-plugin:0.8.1 -> !!!groupId-not-found!!!
# test? ch.qos.logback:logback-core:1.2.11 -> >=dev-java/logback-core-1.2.11:0
# test? com.icegreen:greenmail:1.3 -> !!!groupId-not-found!!!
# test? dom4j:dom4j:1.6.1 -> !!!groupId-not-found!!!
# test? junit:junit:4.10 -> >=dev-java/junit-4.13.2:4
# test? log4j:log4j:1.2.17 -> >=dev-java/log4j-1.2.17:0
# test? org.apache.felix:org.apache.felix.main:2.0.2 -> !!!groupId-not-found!!!
# test? org.assertj:assertj-core:1.7.1 -> >=dev-java/assertj-core-2.3.0:2
# test? org.mockito:mockito-core:2.7.9 -> >=dev-java/mockito-4.4.0:4
# test? org.slf4j:integration:1.7.32 -> !!!artifactId-not-found!!!
# test? org.slf4j:jul-to-slf4j:1.7.32 -> !!!artifactId-not-found!!!
# test? org.slf4j:log4j-over-slf4j:1.7.32 -> !!!artifactId-not-found!!!
# test? org.slf4j:slf4j-api:1.7.32 -> >=dev-java/slf4j-api-1.7.32:0
# test? org.slf4j:slf4j-ext:1.7.32 -> >=dev-java/slf4j-ext-1.7.36:0
# test? org.subethamail:subethasmtp:2.1.0 -> !!!groupId-not-found!!!

# Restricting to jdk:1.8
# src/main/java/ch/qos/logback/classic/spi/PackagingDataCalculator.java:20: error: cannot find symbol
# import sun.reflect.Reflection;
#                   ^
# https://jira.qos.ch/browse/LOGBACK-1343
DEPEND="
	virtual/jdk:1.8
	${CP_DEPEND}"
#	test? (
#		dev-java/dom4j:1
#		dev-java/assertj-core:2
#		dev-java/log4j-12-api:2
#		dev-java/logback-core:0
#		dev-java/mockito:4
#		dev-java/slf4j-api:0
#		dev-java/slf4j-ext:0
#	)
# "

RDEPEND="
	virtual/jre:1.8
	${CP_DEPEND}"

DOCS=( ../README.md )

S="${WORKDIR}/logback-v_${PV}/logback-classic"

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="dom4j-1,logback-core,junit-4,log4j,assertj-core-2,mockito-4,slf4j-api,slf4j-ext"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
