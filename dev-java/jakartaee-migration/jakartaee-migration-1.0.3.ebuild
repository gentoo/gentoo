# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://ftp.fau.de/apache/tomcat/jakartaee-migration/v1.0.3/source/jakartaee-migration-1.0.3-src.tar.gz --slot 0 --keywords "~amd64" --ebuild jakartaee-migration-1.0.3.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.tomcat:jakartaee-migration:1.0.3"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Apache Tomcat tool for migration from Java EE 8 to Jakarta EE 9"
HOMEPAGE="https://tomcat.apache.org"
SRC_URI="mirror://apache/tomcat/${PN}/v${PV}/source/${P}-src.tar.gz -> ${P}-sources.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# Common dependencies
# POM: pom.xml
# commons-io:commons-io:2.8.0 -> >=dev-java/commons-io-2.8.0:1
# org.apache.bcel:bcel:6.5.0 -> >=dev-java/bcel-6.5.0:0
# org.apache.commons:commons-compress:1.20 -> >=dev-java/commons-compress-1.20:0

CDEPEND="
	dev-java/ant-core:0
	dev-java/bcel:0
	>=dev-java/commons-compress-1.20:0
	dev-java/commons-io:1
"

# Compile dependencies
# POM: pom.xml
# org.apache.ant:ant:1.10.9 -> !!!groupId-not-found!!!
# POM: pom.xml
# test? junit:junit:4.13.1 -> >=dev-java/junit-4.13.1:4

DEPEND="
	>=virtual/jdk-1.8:*
	${CDEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}"

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
JAVA_TEST_EXCLUDES=(
	"org.apache.tomcat.jakartaee.TesterConstants"
)

src_prepare() {
	default
	sed -i "s/\${project.version}/${PV}/g" src/main/resources/info.properties
}

src_test() {
	# we need to create jar files for the tests the same way as it's done using pom.xml
	local implementation_version=$(grep Implementation-Version pom.xml | grep -oE "[0-9]+\.[0-9]+\.[0-9]+")
	mkdir -p target/test-classes/META-INF || die
	pushd target/test-classes || die
	echo "Implementation-Version: ${implementation_version}" > META-INF/MANIFEST.MF
	ejavac -d . -encoding ${JAVA_ENCODING} $(find "${S}/${JAVA_TEST_SRC_DIR}" -name CommonGatewayInterface.java) || die
	jar cfm cgi-api.jar META-INF/MANIFEST.MF $(find -name CommonGatewayInterface.class) || die
	ejavac -d . -encoding ${JAVA_ENCODING} $(find "${S}/${JAVA_TEST_SRC_DIR}" -name HelloCGI.java) || die
	jar cfm hellocgi.jar META-INF/MANIFEST.MF $(find -name HelloCGI.class) || die
	for enc in rsa dsa ec; do
		cp hellocgi.jar hellocgi-signed-${enc}.jar || die
		jarsigner -keystore "${S}/src/test/resources/keystore.p12" -storepass apache hellocgi-signed-${enc}.jar ${enc} || die
	done
	popd

	java-pkg-simple_src_test
}
