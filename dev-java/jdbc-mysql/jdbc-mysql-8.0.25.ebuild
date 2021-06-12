# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom mysql-connector-java-8.0.25.pom.xml --download-uri https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.25/mysql-connector-java-8.0.25-sources.jar --slot 0 --keywords "~amd64 ~ppc64 ~x86" --ebuild jdbc-mysql-8.0.25.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source"
MAVEN_ID="mysql:mysql-connector-java:8.0.25"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JDBC Type 4 driver for MySQL"
HOMEPAGE="https://dev.mysql.com/doc/connector-j/en/"
SRC_URI="https://repo1.maven.org/maven2/mysql/mysql-connector-java/${PV}/mysql-connector-java-${PV}-sources.jar -> ${P}-sources.jar"

LICENSE="GPL-2-with-MySQL-FLOSS-exception"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"

# Common dependencies
# POM: mysql-connector-java-${PV}.pom.xml
# com.google.protobuf:protobuf-java:3.11.4 -> !!!groupId-not-found!!!

CDEPEND="dev-java/c3p0:0
	dev-java/protobuf-java:0
	dev-java/slf4j-api:0"
DEPEND=" ${CDEPEND}
	>=virtual/jdk-1.8:* "
RDEPEND=" ${CDEPEND}
	>=virtual/jre-1.8:* "
BDEPEND="app-arch/unzip"

DOCS=( META-INF/README )

S="${WORKDIR}"

JAVA_GENTOO_CLASSPATH="c3p0,protobuf-java,slf4j-api"

JAVA_SRC_DIR="com"
JAVA_RESOURCE_DIRS="res"

src_prepare() {
	default
	mkdir --parents "${JAVA_RESOURCE_DIRS}" || die
	cp -r "${JAVA_SRC_DIR}" "META-INF" "${JAVA_RESOURCE_DIRS}"
	find "${JAVA_RESOURCE_DIRS}" -type f -name '*.java' -exec rm -rf {} + || die
}

src_install() {
	default
	java-pkg-simple_src_install
}
