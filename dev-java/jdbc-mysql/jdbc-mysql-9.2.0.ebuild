# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# No tests, see bug #902723
JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.mysql:mysql-connector-j:9.1.0"
# JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

# Bundling binary versions of oci-java-sdk-common and opentelemetry
# https://github.com/oracle/oci-java-sdk/blob/v2.47.0/bmc-common/pom.xml
OSC="3.29.0"
OAV="1.40.0"

DESCRIPTION="JDBC Type 4 driver for MySQL"
HOMEPAGE="https://dev.mysql.com/doc/connector-j/en/"
SRC_URI="https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-j-${PV}.tar.gz
	https://repo1.maven.org/maven2/com/oracle/oci/sdk/oci-java-sdk-common/${OSC}/oci-java-sdk-common-${OSC}.jar
	https://repo1.maven.org/maven2/io/opentelemetry/opentelemetry-context/${OAV}/opentelemetry-context-${OAV}.jar
	https://repo1.maven.org/maven2/io/opentelemetry/opentelemetry-api/${OAV}/opentelemetry-api-${OAV}.jar"

S="${WORKDIR}/mysql-connector-j-${PV}"

LICENSE="GPL-2-with-MySQL-FLOSS-exception"
SLOT="0"
KEYWORDS="amd64 ~ppc64"

CP_DEPEND="
	dev-java/c3p0:0
	>=dev-java/protobuf-java-4.27.2:0
	dev-java/slf4j-api:0
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( CHANGES README )

JAVA_GENTOO_CLASSPATH_EXTRA="${DISTDIR}/oci-java-sdk-common-${OSC}.jar"
JAVA_GENTOO_CLASSPATH_EXTRA+=":${DISTDIR}/opentelemetry-context-${OAV}.jar"
JAVA_GENTOO_CLASSPATH_EXTRA+=":${DISTDIR}/opentelemetry-api-${OAV}.jar"
JAVA_JAR_FILENAME="mysql-connector-j.jar"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR=(
	"src/generated"
	"src/legacy/java"
	"src/main/core-api/java"
	"src/main/core-impl/java"
	"src/main/protocol-impl/java"
	"src/main/user-api/java"
	"src/main/user-impl/java"
)

src_install() {
	java-pkg-simple_src_install
	java-pkg_newjar "${DISTDIR}/oci-java-sdk-common-${OSC}.jar" oci-java-sdk-common.jar
	java-pkg_newjar "${DISTDIR}/opentelemetry-context-${OAV}.jar" opentelemetry-context.jar
	java-pkg_newjar "${DISTDIR}/opentelemetry-api-${OAV}.jar" opentelemetry-api.jar
	java-pkg_regjar "${ED}/usr/share/jdbc-mysql/lib/oci-java-sdk-common.jar"
}
