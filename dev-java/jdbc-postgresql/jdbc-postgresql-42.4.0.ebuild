# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://jdbc.postgresql.org/download/postgresql-jdbc-42.4.0.src.tar.gz --slot 0 --keywords "~amd64 ~ppc64 ~x86" --ebuild jdbc-postgresql-42.4.0.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.postgresql:postgresql:42.4.0"
# We don't have junit-vintage and junit-jupiter.
#	JAVA_TESTING_FRAMEWORKS="junit-vintage junit-jupiter junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java JDBC 4.2 (JRE 8+) driver for PostgreSQL database"
HOMEPAGE="https://github.com/pgjdbc/pgjdbc"
SRC_URI="https://jdbc.postgresql.org/download/postgresql-jdbc-${PV}.src.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"

# Common dependencies
# POM: pom.xml
# com.ongres.scram:client:2.1 -> !!!groupId-not-found!!!
# uk.org.webcompere:system-stubs-jupiter:1.2.0 -> !!!groupId-not-found!!!

CP_DEPEND="dev-java/scram:0"

# Compile dependencies
# POM: pom.xml
# test? junit:junit:4.13 -> >=dev-java/junit-4.13.2:4
# test? org.junit.jupiter:junit-jupiter-api:5.6.0 -> !!!groupId-not-found!!!
# test? org.junit.jupiter:junit-jupiter-engine:5.6.0 -> !!!groupId-not-found!!!
# test? org.junit.jupiter:junit-jupiter-params:5.6.0 -> !!!groupId-not-found!!!
# test? org.junit.vintage:junit-vintage-engine:5.6.0 -> !!!groupId-not-found!!!
# test? se.jiderhamn:classloader-leak-test-framework:1.1.1 -> !!!groupId-not-found!!!

DEPEND="
	>=virtual/jdk-1.8:*
		${CP_DEPEND}"
#		test? (
#			!!!groupId-not-found!!!
#		)
#	"

RDEPEND="
	>=virtual/jre-1.8:*
		${CP_DEPEND}"

S="${WORKDIR}/postgresql-${PV}-jdbc-src"

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"

#	JAVA_TEST_GENTOO_CLASSPATH="junit-4,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!"
#	JAVA_TEST_SRC_DIR="src/test/java"
#	JAVA_TEST_RESOURCE_DIRS="src/test/resources"
