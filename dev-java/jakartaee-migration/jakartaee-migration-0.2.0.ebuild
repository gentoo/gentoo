# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://ftp.fau.de/apache/tomcat/jakartaee-migration/v0.2.0/source/jakartaee-migration-0.2.0-src.tar.gz --slot 0 --keywords "~amd64 ~x86" --ebuild jakartaee-migration-0.2.0.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.tomcat:jakartaee-migration:0.2.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Apache Tomcat tool for migration from Java EE 8 to Jakarta EE 9."
HOMEPAGE="https://tomcat.apache.org"
SRC_URI="mirror://apache/tomcat/${PN}/v${PV}/source/${P}-src.tar.gz -> ${P}-sources.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

CDEPEND="
	dev-java/ant-core:0
	>=dev-java/bcel-6.5.0:0
	>=dev-java/commons-compress-1.20:0
	dev-java/commons-io:1
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CDEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}
"

S="${WORKDIR}/${P}"

JAVA_LAUNCHER_FILENAME="${PN}"

JAVA_GENTOO_CLASSPATH="ant-core,bcel,commons-compress,commons-io-1"
JAVA_SRC_DIR="src/main/java"
JAVA_MAIN_CLASS="org.apache.tomcat.jakartaee.MigrationCLI"
JAVA_RESOURCE_DIRS=(
	"src/main/resources"
)

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS=(
	"src/test/resources"
)
