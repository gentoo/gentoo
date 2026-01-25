# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple junit5

# Bundling binary versions of oci-java-sdk-common
# According to src/build/misc/pom.xml
OSC="3.66.0"

DESCRIPTION="JDBC Type 4 driver for MySQL"
HOMEPAGE="https://dev.mysql.com/doc/connector-j/en/"
SRC_URI="https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-j-${PV}.tar.gz
	https://repo1.maven.org/maven2/com/oracle/oci/sdk/oci-java-sdk-common/${OSC}/oci-java-sdk-common-${OSC}.jar"

S="${WORKDIR}/mysql-connector-j-${PV}"

LICENSE="GPL-2-with-MySQL-FLOSS-exception"
SLOT="0"
KEYWORDS="~amd64"

# Most tests fail with:
# Cannot connect to MySQL server on localhost:3,306.
# Make sure that there is a MySQL server running on the machine/port you are trying to
# connect to and that the machine this software is running on is able to connect to
# this host/port (i.e. not firewalled). Also make sure that the server has not been
# started with the --skip-networking flag.
RESTRICT="test"

CP_DEPEND="
	dev-java/c3p0:0
	dev-java/opentelemetry-java:0
	>=dev-java/protobuf-java-4.33.0:0
	dev-java/slf4j-api:0
"

DEPEND="
	${CP_DEPEND}
	>=dev-java/guava-33.5.0:0
	dev-java/incap:0
	dev-java/javapoet:0
	>=virtual/jdk-1.8:*
	test? ( >=dev-java/hamcrest-3.0:0 )
"

RDEPEND="
	${CP_DEPEND}
	>=dev-java/jackson-annotations-2.20:0
	>=dev-java/jackson-databind-2.20.0:0
	>=dev-java/jakarta-annotation-api-3.0.0:0
	>=virtual/jre-1.8:*
"

DOCS=( CHANGES README )

JAVA_CLASSPATH_EXTRA="guava incap javapoet"
JAVA_GENTOO_CLASSPATH_EXTRA="${DISTDIR}/oci-java-sdk-common-${OSC}.jar"
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
JAVA_TEST_GENTOO_CLASSPATH="hamcrest junit-5"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	java-pkg-2_src_prepare
	mkdir -p src/main/resources/META-INF/services || die "META-INF"
	# populate META-INF/services according to line 801 build.xml
	echo com.mysql.cj.jdbc.Driver \
		> src/main/resources/META-INF/services/java.sql.Driver || die "META-INF"
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_newjar "${DISTDIR}/oci-java-sdk-common-${OSC}.jar" oci-java-sdk-common.jar
	java-pkg_regjar "${ED}/usr/share/jdbc-mysql/lib/oci-java-sdk-common.jar"
	java-pkg_register-dependency jackson-annotations,jackson-databind,jakarta-annotation-api
}
