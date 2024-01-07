# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.postgresql:postgresql:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java JDBC 4.2 (JRE 8+) driver for PostgreSQL database"
HOMEPAGE="https://jdbc.postgresql.org/"
SRC_URI="https://jdbc.postgresql.org/download/postgresql-jdbc-${PV}.src.tar.gz"
S="${WORKDIR}/postgresql-${PV}-jdbc-src"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"
# package se.jiderhamn.classloader does not exist
# package se.jiderhamn.classloader.leak does not exist
# package uk.org.webcompere.systemstubs.environment does not exist
# package uk.org.webcompere.systemstubs.jupiter does not exist
# package uk.org.webcompere.systemstubs.properties does not exist
# package uk.org.webcompere.systemstubs.resource does not exist
RESTRICT="test" #839681

DEPEND="
	dev-java/checker-framework-qual:0
	dev-java/jna:4
	dev-java/osgi-cmpn:8
	dev-java/osgi-core:0
	dev-java/scram:0
	dev-java/waffle-jna:0
	>=virtual/jdk-1.8:*
	test? ( dev-java/junit:5 )
"

RDEPEND=">=virtual/jre-1.8:*"

JAVA_CLASSPATH_EXTRA="
	checker-framework-qual
	jna-4
	osgi-cmpn-8
	osgi-core
	scram
	waffle-jna
"
JAVA_AUTOMATIC_MODULE_NAME="org.postgresql.jdbc"
JAVA_MAIN_CLASS="org.postgresql.util.PGJDBCMain"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="
	junit-4
	junit-5
"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"
