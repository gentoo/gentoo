# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"
MAVEN_ID="org.postgresql:postgresql:${PV}"

inherit java-pkg-2 java-pkg-simple junit5

DESCRIPTION="Java JDBC 4.2 (JRE 8+) driver for PostgreSQL database"
HOMEPAGE="https://jdbc.postgresql.org/"
CFV="1.1.2"	# classloader-leak-test-framework isn't yet packaged.
WSV="2.1.8"	# webcompere/systemstubs isn't yet packaged.
SRC_URI="https://jdbc.postgresql.org/download/postgresql-jdbc-${PV}.src.tar.gz
	test? (
		https://repo1.maven.org/maven2/uk/org/webcompere/system-stubs-core/${WSV}/system-stubs-core-${WSV}.jar
		https://repo1.maven.org/maven2/uk/org/webcompere/system-stubs-jupiter/${WSV}/system-stubs-jupiter-${WSV}.jar
		https://repo1.maven.org/maven2/se/jiderhamn/classloader-leak-test-framework/${CFV}/classloader-leak-test-framework-${CFV}.jar
	)"
S="${WORKDIR}/postgresql-${PV}-jdbc-src"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

# Tests need a running sql server, otherwise would fail:
# "org.postgresql.util.PSQLException: Connection to localhost:5432 refused.
# Check that the hostname and port are correct and that the postmaster is accepting TCP/IP connections."
RESTRICT="test"

DEPEND="
	>=dev-java/checker-framework-qual-3.52.1:0
	>=dev-java/jna-5.18.1:0
	>=dev-java/osgi-cmpn-8.0.0-r1:8
	>=dev-java/osgi-core-8.0.0:0
	>=dev-java/scram-3.2:0
	>=dev-java/waffle-jna-3.5.1:0
	>=virtual/jdk-1.8:*
	test? (
		>=dev-java/asm-9.9.1:0
		>=dev-java/byte-buddy-1.18.2:0
		dev-java/junit:4
		dev-java/junit:5[vintage]
	)
"

RDEPEND=">=virtual/jre-1.8:*"

JAVA_CLASSPATH_EXTRA="
	checker-framework-qual
	jna
	osgi-cmpn-8
	osgi-core
	scram
	waffle-jna
"

JAVA_AUTOMATIC_MODULE_NAME="org.postgresql.jdbc"
JAVA_GENTOO_CLASSPATH_EXTRA="${DISTDIR}/system-stubs-core-${WSV}.jar"
JAVA_GENTOO_CLASSPATH_EXTRA+=":${DISTDIR}/system-stubs-jupiter-${WSV}.jar"
JAVA_GENTOO_CLASSPATH_EXTRA+=":${DISTDIR}/classloader-leak-test-framework-${CFV}.jar"
JAVA_MAIN_CLASS="org.postgresql.util.PGJDBCMain"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="asm byte-buddy junit-4 junit-5"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"
